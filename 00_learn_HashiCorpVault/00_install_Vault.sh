#!/bin/sh

cd /root

# 0 - Installa dipendenze
sudo apt-get -y install gcc make perl curl

# 1 - Installa HashiCorpt Vault
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get -y update && sudo apt-get -y install vault

sudo mkdir -p ./vault/data

vault -h
vault version

read -p "Installazione completata." tmp

# 2 - Configurazione del file -> config.hcl

addr="$(hostname -I)"
addr=`echo "$addr" | sed 's/ //g'`

sudo cat << EOF > /root/config.hcl
storage "raft" {
  path    = "./vault/data"
  node_id = "node1"
}

listener "tcp" {
  address     = "$addr:8200"
  tls_disable = "true"
}

disable_mlock = true

api_addr = "http://$addr:8200"
cluster_addr = "https://$addr:8201"
ui = true
EOF

read -p "Premere INVIO per avviare il Server Vault." tmp

# 3 - Avvio del Server Vault

vault server -config=config.hcl

# 4 - Inizializzazione del Vault
vault operator init >> chiavi_vault.sh