#!/bin/bash -eu

echo "==> Instalar o Linux/Ubuntu base..."
apt-get install linux-generic linux-headers-`uname -r` ubuntu-minimal dkms -y

echo "==> Instalar pacotes extras..."
apt-get install -y build-essential perl checkinstall libreadline-gplv2-dev \
    libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev \
    libbz2-dev libffi-dev python3-pip unzip lsb-release software-properties-common \
    curl wget git rsync python-dev python3-venv libterm-readline-gnu-perl 	
	
	
echo "==> Instalar pacotes para a criação da imagem ISO..."
apt install -y \
	binutils \
	debootstrap \
	squashfs-tools \
	xorriso \
	grub-pc-bin \
	grub-efi-amd64-bin \
	mtools \
	whois \
	jq \
	moreutils \
	make \
	unzip
