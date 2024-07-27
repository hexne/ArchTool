#! /usr/bin/bash

#
# 运行该脚本需要传入一个参数，即备份文件的完整路径 
#

# main
if [ $# -ne 1 ]; then
    echo "参数数量错误，没有传入备份文件的完整路径,exit"   
    exit
fi

BACKFILE=$1
echo $BACKFILE
 
lsblk
read -p "请选择磁盘" DISK
DISK="/dev/"${DISK}
echo $DISK
DISKP1=${DISK}"p1"
DISKP2=${DISK}"p2"
echo $DISKP1
echo $DISKP2
 
if [ -e $DISK ] ; then
    echo "磁盘存在"
else
    echo "磁盘不存在"
    exit
fi
 
if [ -f $BACKFILE ] ; then
    echo "备份文件存在"
else
    echo "备份文件不存在"
    exit
fi
 
 
sudo mkfs.fat -F 32 $DISKP1
sudo mkfs.ext4 $DISKP2
# 
sudo mount $DISKP2 /mnt
sudo mkdir -p /mnt/boot/efi
sudo mount $DISKP1 /mnt/boot/efi
 
sudo bash -c "genfstab -U -p /mnt > /mnt/etc/fstab"
 
sudo tar -xvzpf $1 -C /mnt --numeric-owner

sudo mkdir /mnt/proc /mnt/dev /mnt/tmp /mnt/sys /mnt/run
sudo cp ./ReMakeGrub.sh /mnt
sudo arch-chroot /mnt bash ReMakeGrub.sh

