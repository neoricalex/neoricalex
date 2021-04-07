#!/bin/bash -eu

echo "==> Remover os pacotes com idioma EN"
apt purge -y language-pack-en \
    language-pack-en-base \
    language-pack-gnome-en \
    language-pack-gnome-en-base

echo "==> Remover os pacotes do Gnome"
apt purge -y adwaita-icon-theme gedit-common gir1.2-gdm-1.0 \
	gir1.2-gnomebluetooth-1.0 gir1.2-gnomedesktop-3.0 gir1.2-goa-1.0 \
	gnome-accessibility-themes gnome-bluetooth gnome-calculator gnome-calendar \
	gnome-characters gnome-control-center gnome-control-center-data \
	gnome-control-center-faces gnome-desktop3-data \
	gnome-font-viewer gnome-getting-started-docs gnome-getting-started-docs-ru \
	gnome-initial-setup gnome-keyring gnome-keyring-pkcs11 gnome-logs \
	gnome-mahjongg gnome-menus gnome-mines gnome-online-accounts \
	gnome-power-manager gnome-screenshot gnome-session-bin gnome-session-canberra \
	gnome-session-common gnome-settings-daemon gnome-settings-daemon-common \
	gnome-shell gnome-shell-common gnome-shell-extension-appindicator \
	gnome-shell-extension-desktop-icons gnome-shell-extension-ubuntu-dock \
	gnome-startup-applications gnome-sudoku gnome-system-monitor gnome-terminal \
	gnome-terminal-data gnome-themes-extra gnome-themes-extra-data gnome-todo \
	gnome-todo-common gnome-user-docs gnome-user-docs-ru gnome-video-effects \
	language-pack-gnome* language-selector-gnome libgail18 libgail18 \
	libgail-common libgail-common libgnome-autoar-0-0 libgnome-bluetooth13 \
	libgnome-desktop-3-19 libgnome-games-support-1-3 libgnome-games-support-common \
	libgnomekbd8 libgnomekbd-common libgnome-menu-3-0 libgnome-todo libgoa-1.0-0b \
	libgoa-1.0-common libpam-gnome-keyring libsoup-gnome2.4-1 libsoup-gnome2.4-1 \
	nautilus-extension-gnome-terminal pinentry-gnome3 yaru-theme-gnome-shell

apt autopurge -y

apt purge -y geogebra-gnome gnome-accessibility-profiles gnome-applets-data gnome-audio gnome-backgrounds \
	gnome-cards-data gnome-common gnome-desktop-testing gnome-dvb-daemon \
	gnome-exe-thumbnailer gnome-extra-icons gnome-flashback-common \
	gnome-humility-icon-theme gnome-hwp-support gnome-icon-theme \
	gnome-icon-theme* gnome-mime-data gnome-nds-thumbnailer \
	gnome-packagekit-data gnome-panel-control gnome-panel-data \
	gnome-pkg-tools gnome-recipes-data gnome-remote-desktop gnome-settings-daemon-dev \
	gnome-shell-pomodoro-data gnome-software-common gnome-software-doc \
	gnome-theme-gilouche gnome-video-effects-extra gnome-video-effects-frei0r \
	guile-gnome2-dev guile-gnome2-glib libgnome-autoar-doc libgnomecanvas2-common \
	libgnomecanvas2-doc libgnomecanvasmm-2.6-doc libgnome-panel-doc libgnome-todo-dev \
	libopenrawgnome7:amd64 libopenrawgnome-dev libreoffice-gnome libxine2-gnome:amd64 \
	nautilus-sendto pidgin-gnome-keyring plymouth-theme-ubuntu-gnome-logo \
	plymouth-theme-ubuntu-gnome-text ubuntu-gnome-wallpapers \
	ubuntu-gnome-wallpapers-bionic ubuntu-gnome-wallpapers-utopic \
	ubuntu-gnome-wallpapers-xenial ubuntu-gnome-wallpapers-yakkety

apt autopurge -y

apt-get remove --auto-remove ubuntu-gnome-desktop -y
apt-get purge ubuntu-gnome-desktop -y
apt-get purge --auto-remove ubuntu-gnome-desktop -y

sudo apt-get autoremove -y
sudo apt-get autoclean -y
sudo apt-get autopurge -y

echo "==> Remover todos os núcleos do linux excepto o que está a ser usado"
dpkg --list 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ :]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge

echo "==> Remover o linux-source"
dpkg --list | awk '{print $2}' | grep linux-source | xargs apt-get -y purge

echo "==> Remover a documentação"
dpkg --list | awk '{print $2}' | grep -- '-doc$' | xargs apt-get -y purge

#apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6 libxau6 libxdmcp6
#apt-get -y purge accountsservice bind9-host busybox-static command-not-found command-not-found-data \
#    dmidecode dosfstools friendly-recovery geoip-database hdparm info install-info installation-report \
#    iso-codes krb5-locales language-selector-common laptop-detect lshw mlocate mtr-tiny nano \
#    ncurses-term nplan ntfs-3g os-prober parted pciutils plymouth popularity-contest powermgmt-base \
#    publicsuffix python-apt-common shared-mime-info ssh-import-id \
#    tasksel tcpdump ufw ureadahead usbutils uuid-runtime xdg-user-dirs
echo "==> Auto-Limpeza"
apt-get -y autoremove --purge

echo "==> Limpar os pacotes orfãos com o deborphan"
apt-get -y install --no-install-recommends deborphan
deborphan --find-config | xargs apt-get -y purge
while [ -n "$(deborphan --guess-all)" ]; do
    deborphan --guess-all | xargs apt-get -y purge
done
apt-get -y purge deborphan

echo "==> Limpar o cache do APT"
apt-get -y autoremove --purge
apt-get -y clean

echo "==> Remover os arquivos do APT"
find /var/lib/apt -type f -exec rm -rf {} \;
echo "==> Remover o cache"
find /var/cache -type f -exec rm -rf {} \;
