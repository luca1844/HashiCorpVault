vault server -dev

# 1 - Create a new token
vault token create

vault login s.iyNUhq8Ov4hIAx6snw5mB2nL

vault token revoke s.iyNUhq8Ov4hIAx6snw5mB2nL

# 2 - GitHub authentication
# The auth method is enabled and available at the path auth/github/
vault auth enable github

# 3 - Set the organization
vault write auth/github/config organization=hashicorp

# 4 - Granted the default and applications policy at GitHub engineering team
# The members of the GitHub engineering team in the hashicorp organization will authenticate and are authorized with the default and applications policies.
vault write auth/github/map/teams/engineering value=default,applications

# 5 - View all authentication methods has enabled
vault auth list

# 6 - Login with GitHub method
unset VAULT_TOKEN
vault login -method=github

vault login root

# 7 - Revoke all tokens generated the github auth method
vault token revoke -mode path auth/

# 8 - Disable github auth method
vault auth disable github