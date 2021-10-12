cd /root

# 1 - Installa Dipendenze
sudo apt-get -y install gcc make perl curl

# 2 - Installa HashiCorp Vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get -y update && sudo apt-get -y install vault

# 3 - Test installazione
vault version

read -p "Installazione completata. Lanciare 'vault agent' per avviare l'Agent."

##################################################################################
##################################################################################

# 1 - Configurazione dell'Agent
