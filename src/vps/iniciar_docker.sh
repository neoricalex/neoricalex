#!/bin/bash

# Instalar o QEMU
#sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils \
#    virtinst virt-manager
#sudo usermod -aG libvirt $USER
#sudo usermod -aG kvm $USER

# WORKAROUND: Qemu fake para compilações amd64 para evitar quebrar o COPY no Dockerfile
# REF: 
QEMU_ARCH=$(uname -m)
QEMU_VERSION="5.2.0-2"
echo "Configurar o pacote estático do QEMU $QEMU_ARCH"

if [[ $QEMU_ARCH == "amd64" ]]; then
    if [ ! -f "x86_64_qemu-"$QEMU_ARCH"-static.tar.gz" ]; then
        touch x86_64_qemu-"$QEMU_ARCH"-static.tar.gz
        mv x86_64_qemu-${QEMU_ARCH}-static.tar.gz docker
    fi
else
    if [ ! -f "x86_64_qemu-"$QEMU_ARCH"-static.tar.gz" ]; then
        curl -L -o x86_64_qemu-"$QEMU_ARCH"-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/"$QEMU_VERSION"/x86_64_qemu-"$QEMU_ARCH"-static.tar.gz
        mv x86_64_qemu-${QEMU_ARCH}-static.tar.gz docker
    fi
fi

exit
cd wireguard/server
chmod +x instalar.sh
./instalar.sh
cd ../..
#docker rm -f wireguard-client
#echo "Y" | docker system prune -a
exit

docker-machine create \
    -d virtualbox \
    swarm-master

eval $(docker-machine env swarm-master)

docker swarm init --advertise-addr $(docker-machine ip swarm-master)

weave launch --ipalloc-init consensus=3

docker run --name consul \
    --restart=always \
    -p 8400:8400 \
    -p 8500:8500 \
    -p 8553:53/udp \
    -d progrium/consul \
    -server -bootstrap-expect 1 -ui-dir /ui

docker stack deploy --compose-file ./wireguard-server/docker-compose.yml wireguard-server

#eval "$(docker-machine env -u)"

#docker-machine rm -f swarm-master