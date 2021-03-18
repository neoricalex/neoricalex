#!/bin/bash

# Iniciar o VPS
# REF: https://github.com/neoricalex/baseimage-docker.git

compilar_local(){
    vagrant destroy
    vagrant up
    vagrant ssh <<EOF
#!/bin/bash
cd /vagrant
make vps
cd ..
EOF
}

compilar_travis(){
    sudo vagrant destroy --force
    sudo vagrant up travis --provider=libvirt
    sudo vagrant ssh <<EOF
#!/bin/bash
cd /vagrant
make vps
cd ..
EOF
}

case $HOSTNAME in
    (travis-job-*) compilar_travis;;
    (*)   compilar_local;;
esac