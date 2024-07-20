#!/usr/bin/bash

YES(){
    yes ""
}
write_xinitrc(){
    echo  "export LANG=zh_CN.utf-8" > ~/.xinitrc
    echo  "export LANGUAGE=zh_CN:en_US" >> ~/.xinitrc

    echo -en "\n\n\n\n" >> ~/.xinitrc
    echo "# 分辨率" >> ~/.xinitrc
    echo -e "xrandr --newmode \"1920x1080_60\" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync" >> ~/.xinitrc
    echo -e "xrandr --addmode Virtual-1 \"1920x1080_60\"" >> ~/.xinitrc
    echo -e "xrandr --output Virtual-1 --mode \"1920x1080_60\"" >> ~/.xinitrc


    echo -en "\n\n\n\n" >> ~/.xinitrc
    echo "# fcitx5" >> ~/.xinitrc
    echo "export GTK_IM_MODULE=fictx5" >> ~/.xinitrc
    echo "export QT_IM_MODULE=fcitx5" >> ~/.xinitrc
    echo "export XMODIFIERS=@im=fcitx5" >> ~/.xinitrc
    echo "fcitx5 &" >> ~/.xinitrc


    echo -en "\n\n\n\n" >> ~/.xinitrc
    echo "# compton" >> ~/.xinitrc
    echo "compton -b &" >> ~/.xinitrc


    echo -en "\n\n\n\n" >> ~/.xinitrc
    echo "# xwinwrap"   >> ~/.xinitrc
    echo "xwinwrap -fs -nf -ov -- mpv --wid=%WID --fps=59 --no-audio --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet ~/.wallpaper/bg.mp4 &" >> ~/.xinitrc
    echo "# xwinwrap -fs -nf -ov -- mplayer -af volume=-200 -fps 24 -shuffle -loop 0 -wid WID -nolirc ~/.wallpaper/bg.mp4 &" >> ~/.xinitrc
    echo "# xwinwrap -fs -nf -ov -- mpv -wid WID --fps=59 --no-audio --loop --no-osc --no-osd-bar --input-vo-keyboard=no --really-quiet ~/.wallpaper/bg.mp4 &" >> ~/.xinitrc




    echo -en "\n\n\n\n" >> ~/.xinitrc
    echo "exec dwm" >> ~/.xinitrc
}

write_compton(){
    mkdir -p ~/.config/compton
    echo     "# 其他窗口不透明度,较高时壁纸更清晰,"      > ~/.config/compton/compton.conf
    echo     "inactive-opacity = 0.95;"             >> ~/.config/compton/compton.conf
    echo     "# 当前聚焦窗口"                        >> ~/.config/compton/compton.conf
    echo     "active-opacity = 0.85;"               >> ~/.config/compton/compton.conf

    echo     "opacity-rule = ["                     >> ~/.config/compton/compton.conf
    echo     "#xprop"                               >> ~/.config/compton/compton.conf
    echo -en "\"79:name *?= 'nvim'&&focused\","     >> ~/.config/compton/compton.conf
    echo     "#nvim被使用"                          >> ~/.config/compton/compton.conf
    echo -en "\"49:name *?= 'nvim'&&!focused\","    >> ~/.config/compton/compton.conf
    echo     "#nvim未被使用"                         >> ~/.config/compton/compton.conf
    echo -en "\"99:class_g = 'firefox'&&focused\"," >> ~/.config/compton/compton.conf
    echo -en "\"99:class_g = 'firefox'&&!focused\",">> ~/.config/compton/compton.conf
    echo     "]"                                    >> ~/.config/compton/compton.conf

    echo     "fading = true;"                       >> ~/.config/compton/compton.conf
    echo     "fade-delta = 15;"                     >> ~/.config/compton/compton.conf
    echo     "fade-in-step = 0.05;"                 >> ~/.config/compton/compton.conf
    echo     "fade-out-step = 0.05;"                >> ~/.config/compton/compton.conf
    echo     "fade-exclude = [ ];"                  >> ~/.config/compton/compton.conf

    echo -en "refresh-rate = 0;"                    >> ~/.config/compton/compton.conf
    echo -en "vsunc = \"none\""                     >> ~/.config/compton/compton.conf

}


YES | sudo pacman -Syy

YES | sudo pacman -S neovim xsel

YES | sudo pacman -S nvidia

YES | sudo pacman -S xorg xorg-xinit xorg-server



# install dwm
cd dwm
sudo make clean install
cd ..

# install pkgfile
YES | sudo pacman -S pkgfile

# install acpi to inquire power information
YES | sudo pacman -S acpi

# install st
cd st
sudo make clean install
cd ..

# install compton
YES | sudo pacman -S picom


# install mplayer / mpv
YES |sudo pacman -S mpv

# install wallpaper player xwinwrap
# git clone https://aur.archlinux.org/xwinwrap-git.git
# cd xwinwrap-git
# YES | makepkg -si
# cd ..
sudo pacman -U xwinwrap.pkg.tar.zst

# install v2ray
# YES | sudo pacman -S v2ray
# git clone https://aur.archlinux.org/v2raya-bin.git
# cd v2raya-bin
# YES | makepkg -si
# sudo systemctl enable --now v2raya.service
# cd ..

# install Chinese font
YES | sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji

# install fcitx5
# /usr/share/fcitx/data/punc.mb.zh_CN
# /usr/share/fcitx5/punctuation
YES | sudo pacman -S fcitx5-im fcitx5-chinese-addons
YES | sudo pacman -S fcitx5-nord

# install firefox and Chinese package
YES | sudo pacman -S firefox firefox-i18n-zh-cn


# install unzip
YES | sudo pacman -S unzip

# install stranstion
YES | sudo pacman -S translate-shell

# install coc depend
YES | sudo pacman -S nodejs npm 
YES | sudo pacman -S clang

# install coc-python depend
YES | sudo pacman -S python-pylint jedi-language-server

# install alsa-utils
YES | sudo pacman -S alsa-utils

# install man-pages-zh_cn
YES | sudo pacman -S man-pages-zh_cn
# auto time
sudo timedatectl set-timezone Asia/Shanghai
sudo timedatectl set-ntp true

# let your user can to reboot/shutdown
sudo chmod u+s /sbin/reboot
sudo chmod u+s /sbin/shutdown

# enable dhcpcd
# sudo systemctl enable dhcpcd

# enable vmware share file
# YES | sudo pacman -S open-vm-tools
# mkdir ~/.share
# sudo /bin/sh -c 'echo ".host:Arch /home/yongheng/.share fuse.vmhgfs-fuse defaults,allow_other 0 0" >> /etc/fstab'

# dwm sh DiskRead and DishWrite
YES | sudo pacman -S bc sysstat


# Clion 
# echo "export _JAVA_AWT_WM_NONREPARENTING=1" >> .bashrc



write_xinitrc
write_compton


cp -r dwm ~/.dwm
cp -r st ~/.st
mkdir ~/.wallpaper
cp bg.mp4 ~/.wallpaper
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/autoload
cp plug.vim ~/.local/share/nvim/site/autoload
