# 1 - Log to Vault
export VAULT_ADDR='http://127.0.0.1:8200'

read -p "Inserisci il token di accesso al Vault: " myToken
export VAULT_TOKEN="$myToken"

# 2 - Writing a Secret
vault kv put secret/file_of_secrets name_secret=value_secret

# 3 - Getting a Secret
vault kv get secret/file_of_secrets

# 4 - Deleting a Secret
vault kv delete secret/file_of_secrets