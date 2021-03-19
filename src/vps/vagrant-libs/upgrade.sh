#!/usr/bin/env bash

# Atualizar Pacotes
sudo apt-get -y upgrade

# Atualizar Distribuição
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