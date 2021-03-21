#!/bin/bash

# NEORICALEX
export NEORICALEX_HOME=$(pwd)

# NFDOS
export NFDOS_HOME=$NEORICALEX_HOME/nfdos
export NFDOS_VERSAO="0.4.4"
export NFDOS_ROOT=$NFDOS_HOME/core
export NFDOS_ROOTFS=$NFDOS_ROOT/rootfs
export NFDOS_DISCO=$NFDOS_ROOT/nfdos.img

# Checkando se a ISO do NFDOS existe
if [ ! -f "$NFDOS_ROOT/nfdos.iso" ]; then
    echo "A $NFDOS_ROOT/nfdos.iso não existe. Criando ela..."
    bash "$NFDOS_ROOT/criar_iso.sh"
else
    echo "A $NFDOS_ROOT/nfdos.iso existe"
fi

# Checkar se a vagrant/NFDOS-$NFDOS_VERSAO.box existe
if [ ! -f "$NFDOS_HOME/desktop/vagrant/NFDOS-$NFDOS_VERSAO.box" ]; then

    echo "A $NFDOS_HOME/desktop/vagrant/NFDOS-$NFDOS_VERSAO.box não existe. Criando ela..."

    echo "Checkando o SHA256 da imagem ISO..."
    checkar_sha256=$(sha256sum $NFDOS_ROOT/nfdos.iso | awk '{ print $1 }')
    jq ".variables.iso_checksum = \"$checkar_sha256\"" $NFDOS_HOME/desktop/desktop.json | sponge $NFDOS_HOME/desktop/desktop.json

    cd $NFDOS_HOME/desktop
    packer build desktop.json #VBoxManage setextradata VM-name "VBoxInternal/TM/TSCTiedToExecution" 1
    cd $NEORICALEX_HOME
    
else
    echo "A $NFDOS_HOME/desktop/vagrant/NFDOS-$NFDOS_VERSAO.box existe."

fi

# TODO:
#   pingar e ssh via hostname: https://www.cyberciti.biz/faq/find-ip-address-of-linux-kvm-guest-virtual-machine/
#   ssh usuario@servidor 'bash -s' < script.sh # Loga, executa, e sai
#   touch ~/.ssh/rc # Executa no background cada vez que o usuario loga normal no ssh

