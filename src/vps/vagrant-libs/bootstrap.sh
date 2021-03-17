#!/usr/bin/env bash
set -eux

# Atualizar Pacotes
sudo apt-get update
# sudo apt-get -y upgrade
# sudo apt-get -y dist-upgrade

# Instalar Linux/Ubuntu base
sudo apt-get install linux-generic linux-headers-`uname -r` ubuntu-minimal -y
#xserver-xorg xserver-xorg-core

# Instalar Pacotes extras
sudo apt-get install -y build-essential checkinstall libreadline-gplv2-dev \
    libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev python3-pip unzip lsb-release software-properties-common \
    curl wget git rsync python-dev python3-venv xrdp libterm-readline-gnu-perl \
    dkms

# Configurar o XRDP
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp

# Instalar o VirtualBox
#sudo apt install -y virtualbox
#sudo apt install -y virtualbox-guest-dkms virtualbox-guest-x11
#sudo apt install -y virtualbox-guest-additions-iso

# Instalar o Extension Pack do VirtualBox
#wget https://download.virtualbox.org/virtualbox/6.1.18/Oracle_VM_VirtualBox_Extension_Pack-6.1.18.vbox-extpack
#sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.18.vbox-extpack --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c
#rm Oracle_VM_VirtualBox_Extension_Pack-6.1.18.vbox-extpack

# Instalar o Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce docker-compose
# Re-instalar o docker-compose
# docker build -t terraform-azure-vm . >> "free(): invalid pointer"
# https://github.com/docker/for-linux/issues/563
sudo apt-get remove -y golang-docker-credential-helpers
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo '{"experimental": true}' > /etc/docker/daemon.json
service docker restart

# Adicionar o usuário neo ao grupo docker
sudo usermod -aG docker neo
