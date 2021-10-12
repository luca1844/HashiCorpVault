# Policies in Vault control what a user can access.

vault server -dev -dev-root-token-id=root

# 1 - View the default policy
vault policy read default

# 2 - Write a policy
vault policy write name_policy - << EOF
# Dev servers have version 2 of KV secrets engine mounted by default, so will
# need these paths to grant permissions:
path "secret/data/*" {
  capabilities = ["create", "update"]
}

path "secret/data/foo" {
  capabilities = ["read"]
}
EOF

# 3 - List all policies
vault policy list

# 4 - View contents of name_policy
vault policy read name_policy

# 5 - Test the policy
# Create a token, add the name_policy policy, and set the token ID as the value of the VAULT_TOKEN environment variable for later use.
export VAULT_TOKEN="$(vault token create -field token -policy=name_policy)"

# 6 - Validate the token ID and view the policy attached
vault token lookup | grep policies

# 7 - Write a secret to the path
vault kv put secret/creds password="my-long-password"

# 8 - Associate Policies to Auth Methods
# You can configure auth methods to automatically assign a set of policies to tokens created by authenticating with certain auth methods.
# verify that approle auth method has not been enabled at the path approle/
vault auth list | grep 'approle/'

vault auth enable approle

# 9 - Enable AppRole named my-role and Attach the name_policy to all tokens when applications authenticate with the role
vault write auth/approle/role/my-role \
    secret_id_ttl=10m \
    token_num_uses=10 \
    token_ttl=20m \
    token_max_ttl=30m \
    secret_id_num_uses=40 \
    token_policies=name_policy


# 10 - To authenticate with AppRole, first fetch the role ID, and capture its value in a ROLE_ID environment variable.
export ROLE_ID="$(vault read -field=role_id auth/approle/role/my-role/role-id)"
export SECRET_ID="$(vault write -f -field=secret_id auth/approle/role/my-role/secret-id)"

vault write auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID"