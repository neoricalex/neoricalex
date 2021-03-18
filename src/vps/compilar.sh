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
    vagrant destroy --force
    vagrant up travis --provider=libvirt
    vagrant ssh <<EOF
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