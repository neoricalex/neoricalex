#!/bin/bash

#sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant up --provider=libvirt
#- sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant ssh -- -t 'sudo apt update; sudo apt install git -y; git clone https://github.com/neoricalex/neoricalex.git; cd neoricalex; bash shell'

vagrant destroy --force
sudo vagrant up --provider=libvirt
sudo vagrant ssh <<EOF
#!/bin/bash

SETAR_HOSTNAME="vps-teste"
sudo echo $SETAR_HOSTNAME > /proc/sys/kernel/hostname
sudo sed -i 's/127.0.1.1.*/127.0.1.1\t'"$SETAR_HOSTNAME"'/g' /etc/hosts
sudo echo $SETAR_HOSTNAME > /etc/hostname
sudo service hostname start
#su $SUDO_USER -c "xauth add $(xauth list | sed 's/^.*\//'"$SETAR_HOSTNAME"'\//g' | awk 'NR==1 {sub($1,"\"&\""); print}')"

echo "$USER@$HOSTNAME"
sudo apt update
sudo apt install git -y
git clone https://github.com/neoricalex/neoricalex.git
cd neoricalex
bash shell
EOF