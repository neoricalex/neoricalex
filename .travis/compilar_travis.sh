#!/bin/bash

#sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant up --provider=libvirt
#- sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant ssh -- -t 'sudo apt update; sudo apt install git -y; git clone https://github.com/neoricalex/neoricalex.git; cd neoricalex; bash shell'
sudo apt update
sudo apt-get install linux-generic linux-headers-`uname -r` ubuntu-minimal -y

sudo apt-get install -y build-essential checkinstall libreadline-gplv2-dev \
    libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev python3-pip unzip lsb-release software-properties-common \
    curl wget git rsync python-dev python3-venv xrdp libterm-readline-gnu-perl \
    dkms git

vagrant destroy --force
sudo vagrant up --provider=libvirt
sudo vagrant ssh <<EOF
#!/bin/bash

sudo apt update
sudo apt-get install linux-generic linux-headers-`uname -r` ubuntu-minimal -y

sudo apt-get install -y build-essential checkinstall libreadline-gplv2-dev \
    libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev python3-pip unzip lsb-release software-properties-common \
    curl wget git rsync python-dev python3-venv xrdp libterm-readline-gnu-perl \
    dkms git

git clone https://github.com/neoricalex/neoricalex.git
cd neoricalex
echo "[DEBUG] Até aqui parece bom!
bash shell
EOF