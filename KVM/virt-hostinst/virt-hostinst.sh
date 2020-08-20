#! /bin/bash
## This program installs KVM service on RHEL(Centos) 7 host
## change and create a new default images location 

set -e

#  Warning
cat << eof
"WARNING! This program should only be run once!"
Type YES to proceed if you run this program for first time on this machine.
eof
read -rp "Press any other key to quit the program!: "

[[ $REPLY != YES ]] && echo quit.. && exit 0

rpm -qa | grep -qE "libvirt|qemu" 
  

# Update System
yum update -y 

# Install Packages
yum -y install \
libvirt \
libvirt-python \
virt-install \
libvirt-client \
qemu-kvm \
qemu-img

# Create VM Images Storage Location
mkdir -p /home/qemu/images

# Change Permission
chown -R qemu:qemu /home/qemu
chcon  --reference /var/lib/libvirt/images /home/qemu/images
chcon  --reference /var/lib/libvirt/images /home/qemu/

# Change Images Storage Location
rmdir /var/lib/libvirt/images
ln -s /home/qemu/images /var/lib/libvirt/images 

# Start Service
systemctl enable libvirtd 
systemctl start libvirtd 

# Testing
#systemctl list-unit-files --state=enabled | grep -q 'libvirtd.service' || echo 'libvirtd service not enabled'
#systemctl is-active libvirtd || echo 'libvirtd service not running'



