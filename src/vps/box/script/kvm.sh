#!/bin/bash -eu

echo "==> Instalar os pacotes do kvm"
apt install -y qemu-system qemu qemu-kvm qemu-utils qemu-block-extra \
					libvirt-daemon libvirt-daemon-system libvirt-clients \
					cpu-checker libguestfs-tools libosinfo-bin \
					bridge-utils dnsmasq-base ebtables libvirt-dev

usermod -aG kvm vagrant
usermod -aG libvirt vagrant

echo "==> Adicionar o grupo kvm"
groupadd kvm

echo "==> Adicionar o usuário vagrant ao grupo kvm"
usermod -aG kvm vagrant

echo "==> Adicionar o usuário vagrant ao grupo libvirt"
usermod -aG libvirt vagrant

echo "==> Iniciar o serviço KVM de forma automática"
systemctl start libvirtd
systemctl enable --now libvirtd

echo "==> Reiniciar o serviço libvirt"
systemctl restart libvirtd.service

echo "==> Habilitar o IPv4 e IPv6 forwarding"
sed -i "/net.ipv4.ip_forward=1/ s/# *//" /etc/sysctl.conf
#sudo sed -i "/net.ipv6.conf.all.forwarding=1/ s/# *//" /etc/sysctl.conf

echo "==> Aplicar as mudanças"
sysctl -p

#sudo chown root:kvm /dev/kvm
#sudo chmod -R 660 /dev/kvm
#sudo udevadm control --reload-rules
#sudo systemctl restart libvirtd
