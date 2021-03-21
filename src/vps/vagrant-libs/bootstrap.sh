#!/usr/bin/env bash
#set -eux

echo "Iniciando a configuração base..."

# TODO: https://stackoverflow.com/questions/13046624/how-to-permanently-export-a-variable-in-linux
# NEORICALEX
export NEORICALEX_HOME=$(pwd)

# NFDOS
export NFDOS_HOME=$NEORICALEX_HOME/nfdos
export NFDOS_VERSAO="0.4.4"
export NFDOS_ROOT=$NFDOS_HOME/core
export NFDOS_ROOTFS=$NFDOS_ROOT/rootfs
export NFDOS_DISCO=$NFDOS_ROOT/nfdos.img

# Packer
export VERSAO_PACKER="1.6.4"
export VERSAO_VAGRANT="2.2.9"

# Atualizar Repositórios
sudo apt-get update

# Instalar Linux/Ubuntu base
sudo apt-get install linux-generic linux-headers-`uname -r` ubuntu-minimal -y

# Instalar Pacotes extras
sudo apt-get install -y build-essential checkinstall libreadline-gplv2-dev \
    libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev python3-pip unzip lsb-release software-properties-common \
    curl wget git rsync python-dev python3-venv libterm-readline-gnu-perl \
    dkms dialog bindfs

echo "Instalar o VirtualBox..."
wget https://download.virtualbox.org/virtualbox/5.2.42/virtualbox-5.2_5.2.42-137960~Ubuntu~bionic_amd64.deb
sudo apt install ./virtualbox-5.2_5.2.42-137960~Ubuntu~bionic_amd64.deb -y
rm virtualbox-5.2_5.2.42-137960~Ubuntu~bionic_amd64.deb

echo "Instalar o Extension Pack do VirtualBox..."
wget https://download.virtualbox.org/virtualbox/5.2.42/Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack
sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack --accept-license=56be48f923303c8cababb0bb4c478284b688ed23f16d775d729b89a2e8e5f9eb
rm Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack

if ! command -v vagrant &> /dev/null
then
    curl -O https://releases.hashicorp.com/vagrant/${VERSAO_VAGRANT}/vagrant_${VERSAO_VAGRANT}_x86_64.deb
    sudo apt install ./vagrant_${VERSAO_VAGRANT}_x86_64.deb
    rm ./vagrant_${VERSAO_VAGRANT}_x86_64.deb
fi

if ! vagrant plugin list | grep -q "vagrant-disksize"
then
    echo "Instalando o plugin vagrant-disksize..."
    vagrant plugin install vagrant-disksize
fi

if ! vagrant plugin list | grep -q "vagrant-bindfs"
then
    echo "Instalando o plugin vagrant-bindfs..."
    # REF: https://github.com/gael-ian/vagrant-bindfs
    vagrant plugin install vagrant-bindfs
fi

if ! vagrant plugin list | grep -q "vagrant-libvirt"
then
    echo "Instalando o plugin vagrant-libvirt..."
    # REF: https://github.com/gael-ian/vagrant-bindfs
    vagrant plugin install vagrant-libvirt
fi


# Instalar o Docker
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo apt-get remove -y golang-docker-credential-helpers

# Instalar o Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
echo '{"experimental": true}' > /etc/docker/daemon.json

# Re-instalar o docker-compose
# docker build -t terraform-azure-vm . >> "free(): invalid pointer"
# https://github.com/docker/for-linux/issues/563

# Instalar o Docker Machine
curl -L https://github.com/docker/machine/releases/download/v0.13.0/docker-machine-`uname -s`-`uname -m` -o ~/docker-machine
chmod +x ~/docker-machine
sudo cp ~/docker-machine /usr/local/bin/

service docker restart

# Adicionar o usuário $USER ao grupo docker
sudo usermod -aG docker $USER

# Instalar & configurar o XRDP
sudo apt install xrdp -y
sudo adduser xrdp ssl-cert
sudo systemctl restart xrdp

# Checkando se a box está preparada
echo "Atualizar os pacotes da box..."
sudo apt update && sudo apt upgrade -y
sudo apt-get -y dist-upgrade
sudo apt --purge autoremove -y
sudo sed -i 's/Prompt=.*/Prompt=lts/' /etc/update-manager/release-upgrades
sudo apt install update-manager-core -y