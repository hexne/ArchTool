source ../head.sh

InstallDesktopSoftware() {
	pwd
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
		cd InstallDWM
		bash install_dwm.sh
		cd ..
		;;
	2) # install KDE
		cd InstallKDE
		bash install_kde.sh
		cd ..
		;;
	3) # quit
		;;
	esac
}


ChooseMenu choose_disk_menu choose_disk_call_back
