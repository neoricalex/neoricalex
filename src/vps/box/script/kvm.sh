#!/bin/bash -eu

echo "==> Instalar os pacotes do kvm"
sudo apt install -y qemu-system qemu qemu-kvm qemu-utils qemu-block-extra \
					libvirt-daemon libvirt-daemon-system libvirt-clients \
					cpu-checker libguestfs-tools libosinfo-bin \
					bridge-utils dnsmasq-base ebtables libvirt-dev

sudo usermod -aG kvm vagrant
sudo usermod -aG libvirt vagrant

echo "==> Adicionar o grupo kvm"
sudo groupadd kvm

echo "==> Adicionar o usuário vagrant ao grupo kvm"
sudo usermod -aG kvm vagrant

echo "==> Adicionar o usuário vagrant ao grupo libvirt"
sudo usermod -aG libvirt vagrant

echo "==> Iniciar o serviço KVM de forma automática"
sudo systemctl start libvirtd
sudo systemctl enable --now libvirtd

echo "==> Reiniciar o serviço libvirt"
sudo systemctl restart libvirtd.service

echo "==> Habilitar o IPv4 e IPv6 forwarding"
sudo sed -i "/net.ipv4.ip_forward=1/ s/# *//" /etc/sysctl.conf
#sudo sed -i "/net.ipv6.conf.all.forwarding=1/ s/# *//" /etc/sysctl.conf

echo "==> Aplicar as mudanças"
sudo sysctl -p

#sudo chown root:kvm /dev/kvm
#sudo chmod -R 660 /dev/kvm
#sudo udevadm control --reload-rules
#sudo systemctl restart libvirtd
