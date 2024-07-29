sudo cp -rf ./custom_grub /usr/share/grub/themes
sudo sh -c 'echo GRUB_THEME=\"/usr/share/grub/themes/Vimix-1080p/Vimix/theme.txt\" >> /etc/default/grub' 
sudo grub-mkconfig -o /boot/grub/grub.cfg
