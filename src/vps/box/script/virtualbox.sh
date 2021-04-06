#!/bin/bash -eu

SSH_USER=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then

	echo "==> Instalar o VirtualBox"
	apt-get install virtualbox virtualbox-guest-dkms -y

    echo "==> Instalar o VirtualBox guest additions"
	apt-get install linux-generic -y
	apt-get install -y dkms build-essential linux-headers-$(uname -r) perl
	apt-get install -y binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers
	apt-get install -y kernel-devel
	apt-get install -y kernel-pae-devel

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

	echo "==> Instalar o Extension Pack do VirtualBox"
	wget https://download.virtualbox.org/virtualbox/5.2.42/Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack \
		-q --show-progress \
		--progress=bar:force:noscroll
	vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack --accept-license=56be48f923303c8cababb0bb4c478284b688ed23f16d775d729b89a2e8e5f9eb # 6.1.16 --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c # 6.1.18 --accept-license=33d7284dc4a0ece381196fda3cfe2ed0e1e8e7ed7f27b9a9ebc4ee22e24bd23c
	rm Oracle_VM_VirtualBox_Extension_Pack-5.2.42.vbox-extpack
fi
