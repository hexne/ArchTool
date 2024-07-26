source ../head.sh

InstallDesktopSoftware() {
    yes "" | sudo pacman -Syyu
    yes "" | sudo pacman -S git
    yes "" | sudo pacman -S neovim  
    yes "" | sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
    yes "" | sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-nord
    yes "" | sudo pacman -S firefox firefox-i18n-zh-cn
    yes "" | sudo pacman -S unzip
}
choose_disk_menu=(
	'1.install desktop software'
	'2.install DWM'
	'3.install KDE'
	'4.quit'
)
choose_disk_call_back() {
	case $cur_choose_menu in
	0) # install desktop software
		InstallDesktopSoftware
		;;
	1) # install DWM
		InstallDesktopSoftware
		cd InstallDWM
		bash install_dwm.sh
		cd ..
		;;
	2) # install KDE
		InstallDesktopSoftware
		cd InstallKDE
		bash install_kde.sh
		cd ..
		;;
	3) # quit
		;;
	esac
}


ChooseMenu choose_disk_menu choose_disk_call_back
