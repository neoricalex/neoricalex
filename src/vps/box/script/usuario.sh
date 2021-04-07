#!/bin/bash

date > /etc/box_build_time

USUARIO_SSH=${SSH_USERNAME:-vagrant}
SENHA_SSH=${SSH_PASSWORD:-vagrant}

# create user, set password and add it to the usual groups
adduser $USUARIO_SSH --gecos "" --home "/home/$USUARIO_SSH" --disabled-password
echo "$USUARIO_SSH:$SENHA_SSH" | chpasswd
usermod -a -G adm,cdrom,sudo,dip,plugdev,lpadmin,sambashare $USUARIO_SSH

# ensure the new user can do passwordless sudo
echo "$USUARIO_SSH ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USUARIO_SSH
chmod 440 /etc/sudoers.d/$USUARIO_SSH

HOME_USUARIO_SSH=${HOME_USUARIO_SSH:-/home/${USUARIO_SSH}}

echo "==> Instalar a Chave SSH Pública do Vagrant"
mkdir $HOME_USUARIO_SSH/.ssh
chmod 700 $HOME_USUARIO_SSH/.ssh
cd $HOME_USUARIO_SSH/.ssh

VAGRANT_INSECURE_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key"

# Fix stdin not being a tty
if grep -q -E "^mesg n$" /root/.profile && sed -i "s/^mesg n$/tty -s \\&\\& mesg n/g" /root/.profile; then
    echo "==> Fixed stdin not being a tty."
fi


# https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
echo "${VAGRANT_INSECURE_KEY}" > $HOME_USUARIO_SSH/.ssh/authorized_keys
chmod 600 $HOME_USUARIO_SSH/.ssh/authorized_keys
chown -R $USUARIO_SSH:$USUARIO_SSH $HOME_USUARIO_SSH/.ssh

echo "==> Criar a HOME do Vagrant"
mkdir $HOME_USUARIO_SSH/.vagrant.d
chown -R $USUARIO_SSH:$USUARIO_SSH $HOME_USUARIO_SSH/.vagrant.d

# set the new user as the default in the login screen and end the current (vagrant) user's gnome session
#mkdir -p /etc/gdm3
#> /etc/gdm3/custom.conf
#echo "[daemon]" >> /etc/gdm3/custom.conf
#echo "# Enabling automatic login" >> /etc/gdm3/custom.conf
#echo "AutomaticLoginEnable = true" >> /etc/gdm3/custom.conf
#echo "AutomaticLogin = $SSH_USER" >> /etc/gdm3/custom.conf

#if [[ $(which gnome-session) ]]; then
#  systemctl restart display-manager
#fi
