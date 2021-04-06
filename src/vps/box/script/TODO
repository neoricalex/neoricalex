#!/bin/bash

#sudo apt install -y \
#	linux-image-5.8.0-45-generic \
#	linux-headers-5.8.0-45-generic \
#	linux-modules-5.8.0-45-generic \
#	linux-modules-extra-5.8.0-45-generic 


#vagrant plugin expunge --force
#sudo apt remove vagrant* -y 
#sudo apt autoremove -y

echo "==> Remover entradas antigas do kernel na Grub..."
# REF: https://askubuntu.com/questions/176322/removing-old-kernel-entries-in-grub
sudo apt-get purge $( dpkg --list | grep -P -o "linux-image-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") ) -y

echo "==> Removendo pacotes desnecessários"
sudo apt autoremove -y

echo "Atualizando os pacotes do VPS_BASE..."
sudo apt update && sudo apt upgrade -y

echo "O VPS_BASE foi provisionado com sucesso!"
echo "Continuando..."
