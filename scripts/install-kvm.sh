#!/bin/bash

echo
echo "--- Install KVM (Ubuntu 18.04 LTS Bonic) ---"
echo

export DEBIAN_FRONTEND="noninteractive"
# Fix some "locale" issues
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo 'LC_ALL="en_US.UTF-8"' >> /etc/default/locale
cd /opt/runlab/
apt update

apt install -y cpu-checker
kvm-ok

apt install -y qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager

systemctl enable libvirtd
systemctl start libvirtd
systemctl status libvirtd

echo
echo "Done."
echo
