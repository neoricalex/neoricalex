#!/bin/bash

source .variaveis_ambiente_vps_dev

compilar_iso(){

	echo "Iniciando a compilação da imagem ISO do NFDOS $NFDOS_VERSAO ..."

	echo "Checkando se a $NFDOS_HOME existe"
	if [ ! -d "$NFDOS_HOME" ]; then
		mkdir -p $NFDOS_HOME
		mkdir -p $NFDOS_HOME/core
		mkdir -p $NFDOS_HOME/desktop
	fi

	echo "Checkando se a $NFDOS_ROOT/nfdos.iso existe"
	if [ ! -f "$NFDOS_ROOT/nfdos.iso" ]; then
		echo "A $NFDOS_ROOT/nfdos.iso não existe. Criando ela..."
		bash "$NFDOS_ROOT/criar_iso.sh"
	else
		echo "A $NFDOS_ROOT/nfdos.iso existe"
	fi

	if [ "$VERSAO_BOX_VAGRANT" == "virtualbox" ]; 
	then
		echo "Checkando se a $NFDOS_HOME/desktop/vagrant/virtualbox/NFDOS-$NFDOS_VERSAO.box existe..."
		if [ ! -f "$NFDOS_HOME/desktop/vagrant/virtualbox/NFDOS-$NFDOS_VERSAO.box" ]; 
		then
			echo "A $NFDOS_HOME/desktop/vagrant/virtualbox/NFDOS-$NFDOS_VERSAO.box não existe. Criando ela..."

			echo "Checkando o SHA256 da imagem ISO..."
			checkar_sha256=$(sha256sum $NFDOS_ROOT/nfdos.iso | awk '{ print $1 }')
			jq ".variables.iso_checksum = \"$checkar_sha256\"" $NFDOS_HOME/desktop/virtualbox.json | sponge $NFDOS_HOME/desktop/virtualbox.json

			cd $NFDOS_HOME/desktop
			packer build virtualbox.json #VBoxManage setextradata VM-name "VBoxInternal/TM/TSCTiedToExecution" 1
			cd $NEORICALEX_HOME
		fi
		echo "A $NFDOS_HOME/desktop/vagrant/virtualbox/NFDOS-$NFDOS_VERSAO.box existe."

	elif [ "$VERSAO_BOX_VAGRANT" == "libvirt" ];
	then
		echo "Checkando se a $NFDOS_HOME/desktop/vagrant/libvirt/NFDOS-$NFDOS_VERSAO.box existe..."
		if [ ! -f "$NFDOS_HOME/desktop/vagrant/libvirt/NFDOS-$NFDOS_VERSAO.box" ]; then

			echo "A $NFDOS_HOME/desktop/vagrant/libvirt/NFDOS-$NFDOS_VERSAO.box não existe. Criando ela..."

			echo "Checkando o SHA256 da imagem ISO..."
			checkar_sha256=$(sha256sum $NFDOS_ROOT/nfdos.iso | awk '{ print $1 }')
			jq ".variables.iso_checksum = \"$checkar_sha256\"" $NFDOS_HOME/desktop/libvirt.json | sponge $NFDOS_HOME/desktop/libvirt.json

			cd $NFDOS_HOME/desktop
			PACKER_LOG=1 packer build libvirt.json # PACKER_LOG=1
			cd $NEORICALEX_HOME
		fi
		echo "A $NFDOS_HOME/desktop/vagrant/libvirt/NFDOS-$NFDOS_VERSAO.box já existe."
	else
		echo "A versão $VERSAO_BOX_VAGRANT do vagrant não é suportada."
	fi

}

entrar_vps(){
	echo "==> Entrando no NFDOS..."
    vagrant ssh <<ENTRAR_VPS
#!/bin/bash

echo ""
echo "O NFDOS foi compilado com Sucesso!"

# TODO: https://www.howtogeek.com/104708/how-to-customize-ubuntus-message-of-the-day/

sudo chown -R neo:neo /var/lib/neoricalex
cd /var/lib/neoricalex

echo "Executar o ansible..."
ansible-pull -i src/vps/nfdos/desktop/ansible/inventory.ini -C master -U https://github.com/neoricalex/neoricalex.git src/vps/nfdos/desktop/ansible/local.yml 

echo "Infos do Wireguard..."
sudo wg show wg0

exit
# TODO: Passar para o Ansible ...

# Wireguard:
#		https://gitlab.com/tangram-vision-oss/tangram-visions-blog/-/tree/main/2021.03.04_AnsibleVpnSetup
#		https://www.tangramvision.com/blog/exploring-ansible-via-setting-up-a-wireguard-vpn

echo "==> Instalar pacotes extras..."
sudo apt-get install -y build-essential make 

if ! command -v vboxmanage &> /dev/null;
then
	echo "==> Instalar o VirtualBox"
	echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian focal contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
	wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install virtualbox -y
	sudo apt install -y virtualbox-guest-dkms #virtualbox-guest-x11
	sudo apt install -y virtualbox-guest-additions-iso

	echo "==> Instalar o Extension Pack do VirtualBox"
	wget https://download.virtualbox.org/virtualbox/6.1.16/Oracle_VM_VirtualBox_Extension_Pack-6.1.16.vbox-extpack \
		-q --show-progress \
		--progress=bar:force:noscroll
	sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.16.vbox-extpack --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c # 6.1.18 --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c
	rm Oracle_VM_VirtualBox_Extension_Pack-6.1.16.vbox-extpack
fi

if ! command -v vagrant &> /dev/null;
then
	echo "==> Download Vagrant & Instalar"
	wget -nv https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb
	sudo dpkg -i vagrant_2.2.14_x86_64.deb
	rm vagrant_2.2.14_x86_64.deb

	echo "==> Instalar requerimentos dos plugins do Vagrant"
	sudo apt install -y \
		ruby-dev ruby-libvirt libxslt-dev libxml2-dev zlib1g-dev libvirt-dev zlib1g-dev

	vagrant plugin install vagrant-libvirt
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-disksize # Só funciona no Virtualbox
	vagrant plugin install vagrant-mutate
	vagrant plugin install vagrant-bindfs

fi

if ! command -v php &> /dev/null;
then
	echo "Instalar o PHP..."
	sudo apt install  -y software-properties-common
	sudo add-apt-repository ppa:ondrej/php
	sudo apt install -y \
		php7.4 php7.4-common php7.4-opcache php7.4-mcrypt php7.4-cli php7.4-gd php7.4-curl php7.4-mysql
fi

if ! command -v composer &> /dev/null;
then
	echo "Instalar o Composer..."
	curl -sS https://getcomposer.org/installer -o composer-setup.php
	sudo php composer-setup.php --install-dir=bin --filename=composer
	sudo mv composer.phar /usr/local/bin/composer
fi

echo "Commitar eventuais modificações..."
git add .
git commit -m "Atualização automática via NFDOS"
ENTRAR_VPS
}


if vagrant status | grep "not created" > /dev/null;
then

	compilar_iso

	echo "==> Adicionar a box neoricalex/nfdos ao Vagrant..."
	vagrant box add \
		--name neoricalex/nfdos \
		--provider $VERSAO_BOX_VAGRANT \
		$NFDOS_HOME/desktop/vagrant/$VERSAO_BOX_VAGRANT/NFDOS-$NFDOS_VERSAO.box

	echo "==> Provisionando o NFDOS..."
    vagrant up --provider $VERSAO_BOX_VAGRANT

	entrar_vps

elif vagrant status | grep "is running" > /dev/null;
then

	entrar_vps

elif vagrant status | grep "shutoff" > /dev/null;
then

	vagrant up --provider $VERSAO_BOX_VAGRANT
	entrar_vps

else

    echo "==> [DEBUG] O NFDOS existe mas está com um status desconhecido:"
	vagrant status 
	sleep 5

fi

#echo "==> [DEBUG] vagrant global-status --prune"
#vagrant global-status --prune
#vagrant destroy -f --name NFDOS

#echo "==> [DEBUG] vboxmanage list vms"
#vboxmanage list vms
#vboxmanage controlvm vps_VPS_1616955616906_88956 poweroff
#vboxmanage unregistervm vps_VPS_1616955616906_88956 --delete
# VBoxManage list vms -l | grep -e ^Name: -e ^State | sed s/\ \ //g | cut -d: -f2-

#echo "==> [DEBUG] vagrant box list"
#vagrant box list
#vagrant box remove neoricalex/nfdos
#vagrant box remove ubuntu/focal64 --all

#echo "==> [DEBUG] virsh vol-list default"
#virsh vol-list default
#virsh vol-delete --pool default neoricalex-VAGRANTSLASH-nfdos_vagrant_box_image_0.img
#virsh vol-delete --pool default NEORICALEX_NFDOS-vdb.qcow2
#virsh vol-delete --pool default NEORICALEX_NFDOS.img
#virsh vol-delete --pool default generic-VAGRANTSLASH-ubuntu2004_vagrant_box_image_3.2.12.img
#virsh vol-delete --pool default NEORICALEX_NFDOS_VPS-vdb.qcow2
#virsh vol-delete --pool default NEORICALEX_NFDOS_VPS.img

#sudo killall vagrant
#sudo killall ruby
