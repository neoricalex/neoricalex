#!/bin/bash

criar_vps(){

	echo "==> Checkar se a neoricalex/ubuntu existe..."
	vps_dev=$(vagrant box list | grep "neoricalex/ubuntu" > /dev/null)
	if [ $? == "1" ];
	then
		echo "==> Checkar se a box base com o Ubuntu foi gerada..."
		if [ ! -f "box/virtualbox/ubuntu-18.04-0.1.box" ];
		then

			if [ -d "box/virtualbox" ];
			then
				rm -rf box/virtualbox
			elif [ -d "box/packer_cache" ];
			then
				rm -rf box/packer_cache
			elif [ vagrant box list | grep "neoricalex/ubuntu" > /dev/null ];
			then
				vagrant box remove neoricalex/ubuntu		
			fi
			echo "==> Criando o VPS_BASE..."
			cd box 
			packer build ubuntu.json
			cd ..
		fi
		echo "==> A box base com o Ubuntu já foi gerada."

	fi

	if ! vagrant box list | grep "neoricalex/ubuntu" > /dev/null;
	then
		echo "==> Adicionar a box neoricalex/ubuntu ao Vagrant..."
		vagrant box add \
			--name neoricalex/ubuntu \
			--provider virtualbox \
			box/virtualbox/ubuntu-18.04-0.1.box
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

if ! vagrant plugin list | grep "vagrant-libvirt" > /dev/null;
then

	echo -e "==> [ WORKAROUND ]: Instalar plugins do Vagrant. \n Não sei porquê, mas se colocarmos a instalação dos plugins nos requerimentos, eles de alguma forma, não ficam \"ativos\" \n"
	vagrant plugin install vagrant-libvirt

	echo -e "==> [ WORKAROUND ]: Certificar em como as permissões do KVM estão setadas. \n Não sei porquê, mas se setarmos as permissões nos requerimentos, elas de alguma forma, não ficam \"ativas\" \n"
	sudo chown root:kvm /dev/kvm
	sudo chmod -R 660 /dev/kvm
	sudo udevadm control --reload-rules
	sudo systemctl restart libvirtd

fi

#echo "Limpando..."
#vagrant destroy -f
#sleep 3
#vagrant box remove neoricalex/nfdos
#sleep 3
#virsh vol-delete --pool default neoricalex-VAGRANTSLASH-nfdos_vagrant_box_image_0.img
#sleep 3
#echo "==> [DEBUG] vagrant global-status --prune"
#vagrant global-status --prune
#sleep 3
#echo "==> [DEBUG] vboxmanage list vms"
#vboxmanage list vms
#sleep 3
#echo "==> [DEBUG] vagrant box list"
#vagrant box list
#sleep 3
#echo "==> [DEBUG] virsh vol-list default"
#virsh vol-list default
#sleep 3

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
	VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant up
	entrar_vps

else

    echo "==> [DEBUG] O VPS_DEV existe mas está com um status desconhecido."
    VAGRANT_VAGRANTFILE=Vagrantfile.VPS_DEV vagrant status 
	sleep 5

fi

