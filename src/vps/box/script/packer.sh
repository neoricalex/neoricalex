#!/bin/bash -eu
	
echo "==> Instalar Packer"
wget https://releases.hashicorp.com/packer/1.6.4/packer_1.6.4_linux_amd64.zip
unzip packer_1.6.4_linux_amd64.zip
sudo mv packer /usr/local/bin 
rm packer_1.6.4_linux_amd64.zip
