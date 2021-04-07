#!/bin/bash -eu

echo "==> Desligar o serviço apt.daily.service & apt-daily-upgrade.service"
systemctl stop apt-daily.timer apt-daily-upgrade.timer
systemctl mask apt-daily.timer apt-daily-upgrade.timer
systemctl stop apt-daily.service apt-daily-upgrade.service
systemctl mask apt-daily.service apt-daily-upgrade.service
systemctl daemon-reload

# install packages and upgrade
echo "==> Atualizar a lista de repositórios"
rm /etc/apt/sources.list

cat <<'EOF' >> /etc/apt/sources.list
#deb cdrom:[Ubuntu 18.04 LTS _Bionic Beaver_ - Release amd64 (20180426)]/ bionic main restricted

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://br.archive.ubuntu.com/ubuntu/ bionic main restricted
deb-src http://br.archive.ubuntu.com/ubuntu/ bionic main restricted

## Major bug fix updates produced after the final release of the
## distribution.
deb http://br.archive.ubuntu.com/ubuntu/ bionic-updates main restricted
deb-src http://br.archive.ubuntu.com/ubuntu/ bionic-updates main restricted

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://br.archive.ubuntu.com/ubuntu/ bionic universe
deb-src http://br.archive.ubuntu.com/ubuntu/ bionic universe
deb http://br.archive.ubuntu.com/ubuntu/ bionic-updates universe
deb-src http://br.archive.ubuntu.com/ubuntu/ bionic-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu 
## team, and may not be under a free licence. Please satisfy yourself as to 
## your rights to use the software. Also, please note that software in 
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
deb http://br.archive.ubuntu.com/ubuntu/ bionic multiverse
deb-src http://br.archive.ubuntu.com/ubuntu/ bionic multiverse
deb http://br.archive.ubuntu.com/ubuntu/ bionic-updates multiverse
deb-src http://br.archive.ubuntu.com/ubuntu/ bionic-updates multiverse

## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
deb http://br.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://br.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu bionic partner
deb-src http://archive.canonical.com/ubuntu bionic partner

deb http://security.ubuntu.com/ubuntu bionic-security main restricted
deb-src http://security.ubuntu.com/ubuntu bionic-security main restricted
deb http://security.ubuntu.com/ubuntu bionic-security universe
deb-src http://security.ubuntu.com/ubuntu bionic-security universe
deb http://security.ubuntu.com/ubuntu bionic-security multiverse
deb-src http://security.ubuntu.com/ubuntu bionic-security multiverse
EOF

apt update && apt upgrade -y 

if [[ $UPDATE =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    apt-get -y dist-upgrade
fi

echo "==> Instalar os pacotes em Português"
apt install -y \
	language-pack-pt \
	language-pack-pt-base

echo "==> Instalando o idioma Português"
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

echo "==> Remover o ubuntu-release-upgrader-core"
#sed -i 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades
apt-get -y purge ubuntu-release-upgrader-core
rm -rf /var/lib/ubuntu-release-upgrader
rm -rf /var/lib/update-manager

echo "==> Limpar o cache do APT"
apt-get -y autoremove --purge
apt-get -y clean

#if [[ $DISABLE_IPV6 =~ true || $DISABLE_IPV6 =~ 1 || $DISABLE_IPV6 =~ yes ]]; then
#    echo "==> Disabling IPv6"
#    sed -i -e 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' \
#        /etc/default/grub
    #update-grub
#fi

echo "==> Remover o timeout da grub e o splash screen"
sed -i -e '/^GRUB_TIMEOUT=/aGRUB_RECORDFAIL_TIMEOUT=0' \
    -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash"/' \
    /etc/default/grub
update-grub

#echo "==> Desligar o DNS do SSH"
#echo "UseDNS no" >> /etc/ssh/sshd_config

echo "====> Desligar o serviço SSHD e reiniciar..."
systemctl stop sshd.service
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 120
exit 0
