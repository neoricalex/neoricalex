#!/bin/bash -eu

echo "==> Instalar os pacotes em Português"
apt install -y \
	language-pack-pt \
	language-pack-pt-base

echo "==> Remover os pacotes com idioma EN"
apt purge -y language-pack-en \
    language-pack-en-base \
    language-pack-gnome-en \
    language-pack-gnome-en-base

echo -e "$inicio_cor ==> Instalando o idioma Português $fim_cor"
echo "America/Sao_Paulo" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata && \
	locale-gen --purge pt_BR.UTF-8 && \
	sed -i -e 's/# pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/' /etc/locale.gen && \
	echo 'LANG="pt_BR.UTF-8"\nLANGUAGE="pt_BR:pt"\n'>/etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=pt_BR.UTF-8 LANGUAGE=pt_BR

echo "==> Gerar o idioma pt_BR"
LANG=pt_BR.UTF-8
LC_ALL=$LANG
locale-gen --purge $LANG
update-locale LANG=$LANG LC_ALL=$LC_ALL

apt install -y `check-language-support -l pt_BR`

# Remove some packages to get a minimal install
echo "==> Removing all linux kernels except the currrent one"
dpkg --list 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ :]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge
echo "==> Removing linux source"
dpkg --list | awk '{print $2}' | grep linux-source | xargs apt-get -y purge
echo "==> Removing documentation"
dpkg --list | awk '{print $2}' | grep -- '-doc$' | xargs apt-get -y purge
echo "==> Removing X11 libraries"
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6 libxau6 libxdmcp6
echo "==> Removing other oddities"
apt-get -y purge accountsservice bind9-host busybox-static command-not-found command-not-found-data \
    dmidecode dosfstools friendly-recovery geoip-database hdparm info install-info installation-report \
    iso-codes krb5-locales language-selector-common laptop-detect lshw mlocate mtr-tiny nano \
    ncurses-term nplan ntfs-3g os-prober parted pciutils plymouth popularity-contest powermgmt-base \
    publicsuffix python-apt-common shared-mime-info ssh-import-id \
    tasksel tcpdump ufw ureadahead usbutils uuid-runtime xdg-user-dirs
apt-get -y autoremove --purge

# Clean up orphaned packages with deborphan
apt-get -y install --no-install-recommends deborphan
deborphan --find-config | xargs apt-get -y purge
while [ -n "$(deborphan --guess-all)" ]; do
    deborphan --guess-all | xargs apt-get -y purge
done
apt-get -y purge deborphan

# Clean up the apt cache
apt-get -y autoremove --purge
apt-get -y clean

echo "==> Removing APT files"
find /var/lib/apt -type f -exec rm -rf {} \;
echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;
