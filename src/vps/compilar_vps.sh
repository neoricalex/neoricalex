#!/bin/bash

criar_vps(){

	echo "==> Checkar se a box do Vagrant neoricalex/ubuntu existe..."
	vps_dev=$(vagrant box list | grep "neoricalex/ubuntu" > /dev/null)
	if [ $? == "1" ];
	then
		echo "==> Checkar se a box base com o Ubuntu foi gerada..."
		if [ ! -f "box/virtualbox/VPS_DEV-0.1.box" ];
		then

			if [ -d "box/virtualbox" ]; then
				rm -rf box/virtualbox
			elif [ -d "box/packer_cache" ]; then
				rm -rf box/packer_cache	
			fi
			
			echo "==> Criando a box base com o Ubuntu: VPS_DEV..."
			cd box 
			packer build ubuntu.json
			cd ..
		fi
		echo "==> A box base do VPS_DEV já foi gerada."

	fi

	if ! vagrant box list | grep "neoricalex/ubuntu" > /dev/null;
	then
		echo "==> Adicionar a box neoricalex/ubuntu ao Vagrant..."
		vagrant box add \
			--name neoricalex/ubuntu \
			--provider virtualbox \
			box/virtualbox/VPS_DEV-0.1.box
	fi
	echo "==> A neoricalex/ubuntu já existe."
	
	echo "==> Provisionando o VPS_DEV..."
	VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant up
	echo "==> Reiniciando o VPS_DEV para as configurações ficarem ativas..."
	VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant reload
}

entrar_vps(){
	echo "==> Entrando no VPS_DEV..."
	VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant ssh<<EOF
#!/bin/bash

cd /neoricalex

if ! command -v vboxmanage &> /dev/null;
then
	echo "==> Instalar o VirtualBox"
	sudo apt update && sudo apt-get install -y virtualbox virtualbox-guest-dkms virtualbox-guest-x11

	echo "==> Instalar o Extension Pack do VirtualBox"
	wget https://download.virtualbox.org/virtualbox/5.2.42/Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack \
		-q --show-progress \
		--progress=bar:force:noscroll
	sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack --accept-license=56be48f923303c8cababb0bb4c478284b688ed23f16d775d729b89a2e8e5f9eb # 6.1.16 --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c # 6.1.18 --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c
	rm Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack
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
	#vagrant plugin install vagrant-vbguest
	#vagrant plugin install vagrant-disksize # Só funciona no Virtualbox
	#vagrant plugin install vagrant-mutate
	#vagrant plugin install vagrant-bindfs
	#vagrant plugin install vagrant-cachier
fi

if ! command -v packer &> /dev/null;
then
	echo "==> Instalar Packer"
	sudo apt install -y wget unzip
	wget https://releases.hashicorp.com/packer/1.6.4/packer_1.6.4_linux_amd64.zip
	unzip packer_1.6.4_linux_amd64.zip
	sudo mv packer /usr/local/bin 
	rm packer_1.6.4_linux_amd64.zip
fi

if ! command -v kvm-ok &> /dev/null;
then
	echo "==> Instalar os pacotes do kvm"
	sudo apt install -y qemu-system qemu qemu-kvm qemu-utils qemu-block-extra \
						libvirt-daemon libvirt-daemon-system libvirt-clients \
						cpu-checker libguestfs-tools libosinfo-bin \
						bridge-utils dnsmasq-base ebtables libvirt-dev

	sudo usermod -aG kvm vagrant
	sudo usermod -aG libvirt vagrant

	echo "==> Adicionar o grupo kvm"
	sudo groupadd kvm

	echo "==> Adicionar o usuário vagrant ao grupo kvm"
	sudo usermod -aG kvm vagrant

	echo "==> Adicionar o usuário vagrant ao grupo libvirt"
	sudo usermod -aG libvirt vagrant

	echo "==> Iniciar o serviço KVM de forma automática"
	sudo systemctl start libvirtd
	sudo systemctl enable --now libvirtd

	echo "==> Reiniciar o serviço libvirt"
	sudo systemctl restart libvirtd.service

	echo "==> Habilitar o IPv4 e IPv6 forwarding"
	sudo sed -i "/net.ipv4.ip_forward=1/ s/# *//" /etc/sysctl.conf
	sudo sed -i "/net.ipv6.conf.all.forwarding=1/ s/# *//" /etc/sysctl.conf

	echo "==> Aplicar as mudanças"
	sudo sysctl -p

	sudo chown root:kvm /dev/kvm
	sudo chmod -R 660 /dev/kvm
	sudo udevadm control --reload-rules
	sudo systemctl restart libvirtd
fi

#vagrant destroy -f
#vagrant box remove neoricalex/nfdos
#virsh vol-delete --pool default neoricalex-VAGRANTSLASH-nfdos_vagrant_box_image_0.img
#virsh vol-delete --pool default NEORICALEX_NFDOS-vdb.qcow2

echo "Compilando o NFDOS..."
make nfdos

cd ..
EOF
}

if VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant status | grep "not created" > /dev/null;
then

    criar_vps
	entrar_vps

elif VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant status | grep "is running" > /dev/null;
then

	entrar_vps

elif VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant status | grep "aborted" > /dev/null;
then

	vboxmanage startvm VPS_DEV --type headless
	VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant up --provision
	criar_vps
	entrar_vps

else

    echo "==> [DEBUG] O VPS_DEV existe mas está com um status desconhecido."
    VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant status 
	sleep 5

fi

