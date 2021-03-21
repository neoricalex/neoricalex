#!/bin/bash

# Hashicorp
export VERSAO_PACKER="1.6.4"
export VERSAO_VAGRANT="2.2.9"

echo "Iniciando a configuração base..."
# REF: https://stackoverflow.com/questions/13046624/how-to-permanently-export-a-variable-in-linux

echo "Atualizar os pacotes da box..."
sudo apt update && sudo apt upgrade -y
sudo apt-get -y dist-upgrade
sudo apt --purge autoremove -y
sudo sed -i 's/Prompt=.*/Prompt=lts/' /etc/update-manager/release-upgrades
sudo apt install update-manager-core -y

echo "Instalar Linux/Ubuntu base..."
sudo apt-get install linux-generic linux-headers-`uname -r` ubuntu-minimal -y

echo "Instalar Pacotes extras..."
sudo apt-get install -y \
    autoconf \
    build-essential bindfs binutils bridge-utils \
    checkinstall curl \
    debootstrap dkms dialog dnsmasq-base \
    ebtables \
    grub-pc-bin grub-efi-amd64-bin git  \
    jq \
    libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev lsb-release libterm-readline-gnu-perl \
    libvirt-daemon-system libvirt-clients libvirt-dev \
    mtools moreutils make \
    python-dev python3-venv python3-pip \
    qemu-kvm qemu-utils \
    rsync ruby-dev \
    software-properties-common squashfs-tools \
    tmux tk-dev \
    unzip \
    xorriso \
    wget whois

echo "Instalar o VirtualBox..."
wget https://download.virtualbox.org/virtualbox/5.2.42/virtualbox-5.2_5.2.42-137960~Ubuntu~bionic_amd64.deb
sudo apt install ./virtualbox-5.2_5.2.42-137960~Ubuntu~bionic_amd64.deb -y
rm virtualbox-5.2_5.2.42-137960~Ubuntu~bionic_amd64.deb

echo "Instalar o Extension Pack do VirtualBox..."
wget https://download.virtualbox.org/virtualbox/5.2.42/Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack
sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack --accept-license=56be48f923303c8cababb0bb4c478284b688ed23f16d775d729b89a2e8e5f9eb
rm Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack

echo "Instalar o Vagrant..."
curl -O https://releases.hashicorp.com/vagrant/${VERSAO_VAGRANT}/vagrant_${VERSAO_VAGRANT}_x86_64.deb
sudo apt install ./vagrant_${VERSAO_VAGRANT}_x86_64.deb
rm ./vagrant_${VERSAO_VAGRANT}_x86_64.deb

echo "Instalar os plugins do Vagrant..."
vagrant plugin install vagrant-disksize

# REF: https://github.com/gael-ian/vagrant-bindfs
vagrant plugin install vagrant-bindfs

# REF: https://github.com/gael-ian/vagrant-bindfs
vagrant plugin install vagrant-libvirt

echo "Instalar o Packer..."
wget https://releases.hashicorp.com/packer/${VERSAO_PACKER}/packer_${VERSAO_PACKER}_linux_amd64.zip
unzip packer_${VERSAO_PACKER}_linux_amd64.zip
sudo mv packer /usr/local/bin 
rm packer_${VERSAO_PACKER}_linux_amd64.zip

echo "Instalar o Docker..."
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo apt-get remove -y golang-docker-credential-helpers

echo "Instalar o Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo '{"experimental": true}' > /etc/docker/daemon.json

# Re-instalar o docker-compose
# docker build -t terraform-azure-vm . >> "free(): invalid pointer"
# https://github.com/docker/for-linux/issues/563

echo "Instalar o Docker Machine..."
curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` -o ~/docker-machine
chmod +x ~/docker-machine
sudo cp ~/docker-machine /usr/local/bin/

service docker restart

echo "Adicionar o usuário $USER ao grupo docker..."
sudo usermod -aG docker $USER

echo "Instalar & configurar o XRDP..."
sudo apt install xrdp -y
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp

echo "Limpando..."
sudo apt --purge autoremove -y