# chinese local
# in file /etc/locale.gen
# zh_CN en_US => utf8 gbk ...
# locale-gen
# modify kde local or /etc/locale.conf


# install paru
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si
cd ..


# install v2ray v2raya
yes "" | sudo pacman -S v2ray
git clone https://aur.archlinux.org/v2raya-bin.git
cd v2raya-bin
makepkg -si
cd ..
sudo systemctl enable --now v2raya



paru -S clion clion-gbk clion-cmake clion-jre


# install neovim coc plug
yes "" | sudo pacman -S nodejs npm

# coc-python depend
yes "" | sudo pacman -S python-pylint jedi-language-server

# install coc plug
coc-sh
coc-clangd
coc-marketplace : CocList marketplace

# kde cursor name
Twilight Cursors

# background

# start background


# oh my zsh
sh -c "$(curl -fsSL https://install.ohmyz.sh/)"
# 取消 “使用粗体绘制强烈颜色” 功能

# 高亮
sudo pacman -S zsh-syntax-highlighting
sudo pacman -S zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# fstab
# sda2
UUID=E820CEE820CEBCB6 	/home/yongheng/.SSS  ntfs umask=022,uid=1000,gid=1000 0 0