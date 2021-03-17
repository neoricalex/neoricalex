#!/bin/bash

# Fazer o Upload da inagem base do docker
if [ ! -d "core" ] ; then
        usuario="$(whoami)@$(hostname | cut -d . -f 1-2)"
        if [ "$usuario" == "neo@desktop" ]; then
                sudo debootstrap --arch=amd64 --variant=minbase focal core
                sudo tar -C core -c . | sudo docker import - core
                sudo docker tag core neoricalex/nfdos
                sudo docker login
                sudo docker push neoricalex/nfdos
                sudo docker logout
        fi
fi

# Fazer o Upload do VPS para a Cloud do Vagrant
usuario="$(whoami)@$(hostname | cut -d . -f 1-2)"
if [ "$usuario" == "neo@desktop" ]; then
        vagrant cloud auth login
        vagrant cloud publish \
        --box-version $NFDOS_VERSAO \
        --release \
        neoricalex/nfdos $NFDOS_VERSAO virtualbox \
        neoricalex/nfdos/desktop/vagrant/NFDOS-$NFDOS_VERSAO.box # --force --debug
        vagrant cloud auth logout
fi

# TODO: Fazer o Upload do NEORICALEX para o github