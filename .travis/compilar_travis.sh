#!/bin/bash

#sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant up --provider=libvirt
#- sudo VAGRANT_VAGRANTFILE=src/vps/.travis/Vagrantfile vagrant ssh -- -t 'sudo apt update; sudo apt install git -y; git clone https://github.com/neoricalex/neoricalex.git; cd neoricalex; bash shell'

vagrant destroy --force
sudo vagrant up --provider=libvirt
sudo vagrant ssh <<EOF
#!/bin/bash

sudo apt update
sudo apt install git -y
git clone https://github.com/neoricalex/neoricalex.git

echo "[DEBUG] Até aqui parece bom!"

cd neoricalex/src

chmod +x iniciar_desenvolvimento.sh
./iniciar_desenvolvimento.sh
EOF
