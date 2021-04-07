#!/bin/bash -eu

USUARIO_SSH=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then

    echo "==> Instalar o guest additions do VirtualBox"
    VBOX_VERSION=$(cat /home/${USUARIO_SSH}/.vbox_version)
    mount -o loop /home/${USUARIO_SSH}/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
    yes|sh /mnt/VBoxLinuxAdditions.run
    umount /mnt
    rm /home/${USUARIO_SSH}/VBoxGuestAdditions_$VBOX_VERSION.iso
    rm /home/${USUARIO_SSH}/.vbox_version

    if [[ $VBOX_VERSION = "4.3.10" ]]; then
        ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
    fi
    if [[ $VBOX_VERSION = "6.1.16" ]]; then
        rm /sbin/mount.vboxsf && ln -s /usr/lib/VBoxGuestAdditions/mount.vboxsf /sbin/mount.vboxsf
    fi

fi
