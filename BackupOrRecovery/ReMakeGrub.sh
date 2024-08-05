#!/usr/bin/bash

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --verbose &> grubinstall.log
grub-mkconfig -o /boot/grub/grub.cfg

mkinitcpio -p linux
