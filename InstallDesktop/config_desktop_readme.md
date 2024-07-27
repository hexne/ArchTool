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



paru -S clion clion-gbk clion-cmake


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


