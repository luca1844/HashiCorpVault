# Secrets engines are Vault components which store, generate or encrypt secrets.

# 1 - Enable a Secrets Engine
# Each path is completely isolated and cannot talk to other paths.
vault secrets enable my_secrets_engine

# 2 - List of Secrets Engine
vault secrets list

# 3 - Create Secrets in Secrets Engine
vault kv put my_secrets_engine/file_of_secrets name_secret=value_secret

vault kv put my_secrets_engine/my_secret value="s3c(eT"

vault kv delete my_secrets_engine/file_of_secrets

vault kv list my_secrets_engine/

# 4 - Disable Secrets Engine
vault secrets disable my_secrets_engine/