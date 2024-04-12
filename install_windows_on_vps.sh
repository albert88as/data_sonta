#!/bin/bash
sudo su
apt update && apt upgrade -y
apt install gparted filezilla grub2 wimtools -y
(echo r; echo g; echo p; echo w; echo y) | gdisk /dev/sda
mount /dev/sda1 /mnt
cd ~
mkdir winsv
mount /dev/sda2 winsv
grub-install --root-directory=/mnt /dev/sda
cd /mnt/boot/grub

echo -e 'set timeout=10
menuentry "windows installer" {
	insmod ntfs
	search --set=root --file=/bootmgr
	ntldr /bootmgr
	boot
}' >> /mnt/boot/grub/grub.cfg

cd /root/winsv
mkdir winfile
wget -O winsv.iso https://iso.cloudmini.net/0:/Windows_Server_2019.iso
mount -o loop winsv.iso winfile
rsync -avz --progress winfile/* /mnt
umount winfile
wget -O virtio.iso https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso
mount -o loop virtio.iso winfile
mkdir /mnt/sources/virtio
cd /mnt/sources
mount /root/winsv/winfile /mnt/sources/virtio
mount -o loop /root/winsv/virtio.iso /mnt/sources/virtio
ls ./virtio
touch cmd.txt
echo 'add virtio /virtio_drivers' >> cmd.txt
wimlib-imagex update boot.wim 2 < cmd.txt
reboot