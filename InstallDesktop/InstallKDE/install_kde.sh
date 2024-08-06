yes "" | sudo pacman -S plasma-meta
yes "" | sudo pacman -S konsole 
yes "" | sudo pacman -S dolphin
yes "" | sudo pacman -S flameshot # 火焰截图
sudo systemctl enable --now sddm
sudo systemctl enable --now NetworkManager


mkdir -p ~/.config/nvim
cp ../InstallDWM/init.vim ~/.config/nvim
mkdir -p ~/.local/share/nvim/site/autoload
cp ../InstallDWM/plug.vim ~/.local/share/nvim/site/autoload

