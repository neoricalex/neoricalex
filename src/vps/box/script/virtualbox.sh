#!/bin/bash -eu

SSH_USER=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then

    echo "==> Instalar o VirtualBox guest additions"
	apt-get install linux-generic -y
	apt-get install -y dkms build-essential linux-headers-$(uname -r) perl
	apt-get install -y binutils gcc make patch

    VBOX_VERSION=$(cat /home/${SSH_USER}/.vbox_version)
    mount -o loop /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    yes|sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm /home/${SSH_USER}/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/${SSH_USER}/.vbox_version

    if [[ $VBOX_VERSION = "4.3.10" ]]; then
        ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    fi
    if [[ $VBOX_VERSION = "6.1.16" ]]; then
        rm /sbin/mount.vboxsf && ln -s /usr/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf
    fi

fi
