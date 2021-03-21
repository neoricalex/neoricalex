#!/bin/bash

# Iniciar o VPS
# REF: https://github.com/neoricalex/baseimage-docker.git

#vagrant destroy
vagrant up --provider=libvirt
vagrant reload
vagrant ssh <<EOF
#!/bin/bash

cd /vagrant
make vps
cd ..

EOF
exit
vagrant reload
vagrant ssh <<EOF
#!/bin/bash

echo "Atualizar a Distribuição da box..."

if [[ -r /etc/os-release ]]; then
    . /etc/os-release
    if [[ $VERSION_ID = "20.04" ]]; then
        read _ UBUNTU_VERSION_NAME <<< "$VERSION"
        echo "Running Ubuntu $UBUNTU_VERSION_NAME"
    else
        echo "Not running an Ubuntu distribution. ID=$ID, VERSION=$VERSION"
        sudo apt-get -y dist-upgrade
        sudo apt --purge autoremove -y
        sudo sed -i 's/Prompt=.*/Prompt=lts/' /etc/update-manager/release-upgrades
        sudo apt install update-manager-core -y
        ( echo "y"; echo ""; echo "y"; ) | sudo do-release-upgrade -d
    fi
else
    echo "Not running a distribution with /etc/os-release available"
fi

( echo "y"; echo ""; echo "y"; ) | sudo do-release-upgrade -d

EOF

# REF: https://stackoverflow.com/questions/33662074/vagrant-difference-between-package-and-repackage
#vagrant package --output vm1-package.box 


# sudo apt install ruby
# sudo gem install travis 
# travis lint