#!/bin/bash

# Iniciar o VPS
# REF: https://github.com/neoricalex/baseimage-docker.git

compilar_local(){
    vagrant destroy
    sudo vagrant up
    sudo vagrant ssh <<EOF
#!/bin/bash
ls .
cd /vagrant
make vps
cd ..
EOF
    # REF: https://stackoverflow.com/questions/33662074/vagrant-difference-between-package-and-repackage
    #vagrant package --output vm1-package.box 
}

compilar_travis(){
    sudo VAGRANT_VAGRANTFILE=Vagrantfile.travis vagrant up --provider=libvirt
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

# sudo apt install ruby
# sudo gem install travis 
# travis lint