#!/bin/bash

#sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant up --provider=libvirt
#- sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant ssh -- -t 'sudo apt update; sudo apt install git -y; git clone https://github.com/neoricalex/neoricalex.git; cd neoricalex; bash shell'

sudo vagrant up --provider=libvirt
sudo vagrant ssh <<EOF
#!/bin/bash
pwd
ls
sudo apt update
sudo apt install git -y
git clone https://github.com/neoricalex/neoricalex.git
cd neoricalex
bash shell
EOF