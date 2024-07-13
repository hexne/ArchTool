source ./head.sh


cur_choose_menu=0

choose_disk_menu=(
	'1.install arch system'
	'2.install desktop'
	'3.backup or recovery'
	'4.quit this tool'
)
choose_disk_call_back() {
	case $cur_choose_menu in
	0) # install system
		bash install_system.sh
	;;
	1) # install desktop
		bash install_desktop.sh
	;;
	2) # backup or recovryr
		bash backup_or_recovery.sh
	;;
	3) # quit this tool
	;;
	esac
}

ChooseMenu choose_disk_menu choose_disk_call_back

