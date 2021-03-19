#!/bin/bash

# Criar a neoricalex/nfdos no Docker Hub
publicar_imagem(){
    usuario="$(whoami)@$(hostname | cut -d . -f 1-2)"
    if [ "$usuario" == "neo@desktop" ]; then
            sudo tar -C nfdos/core/rootfs -c . | sudo docker import - nfdos/core/rootfs
            sudo docker tag core neoricalex/nfdos
            sudo docker login
            sudo docker push neoricalex/nfdos
            sudo docker logout
    fi
}

if [ ! -d "nfdos/core/rootfs" ] ; then
    sudo debootstrap --arch=amd64 --variant=minbase focal nfdos/core/rootfs
    publicar_imagem
fi
