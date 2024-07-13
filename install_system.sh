source ./head.sh

YES() {
    yes ""
}

FormatDisk() {

    disk_name=${disk_name_list[(($cur_choose_menu+1))]}
    echo "$disk_name"
    disk_type=${disk_type_list[(($cur_choose_menu+1))]}


    disk_name="/dev/""$disk_name"
    if [ $disk_type == "SSD" ];then
        efi_disk_name="$disk_name""p1"
        main_part_disk_name="$disk_name""p2"
        echo $efi_disk_name 
        echo $main_part_disk_name 
    elif [ $disk_type == "HDD" ]; then
        efi_disk_name="$disk_name""1"
        main_part_disk_name="$disk_name""2"
        echo $efi_disk_name 
        echo $main_part_disk_name 
    else
        echo "this disk type is not support"
    fi

    read -p "input efi size, (unit is M, only input number) :" efi_disk_size
    efi_disk_size="+""$efi_disk_size""M"

    echo $efi_disk_size

    
    # @TODO ,only support ext4 ,unsupport btrfs
    echo -en "o\nn\n\n\n\n$efi_disk_size\nn\n\n\n\n\nw\n" | fdisk $efi_disk_name

    YES | mkfs.fat -F 32 $efi_disk_name
    YES | mkfs.ext4 $main_part_disk_name


    mount $main_part_disk_name /mnt
    mkdir -p /mnt/boot/efi
    mount $efi_disk_name /mnt/boot/efi

    # @TODO, only support linux
    # @TODO, 网络连接使用dhcpcd和iwd
    YES | pacman -Sy archlinux-keyring
    YES | pacstrap -i /mnt base base-devel linux linux-firmware dhcpcd iwd


    genfstab -U /mnt >> /mnt/etc/fstab
    
    cp install_system.sh /mnt
    arch-chroot /mnt bash install_system.sh chroot_behind


    umount /mnt/boot/efi
    umount /mnt

}

Front() {
    local GetDIskInfo="lsblk -d -o name,size,rota"
    local disk_name_list=(`$GetDIskInfo | awk '{ print $1 }'`)
    local size_list=(`$GetDIskInfo | awk '{ print $2 }'`)
    local disk_type_list=(`$GetDIskInfo | awk '{ print $3 }'`)

    
    local choose_disk_menu_list=()

    local disk_count=${#disk_name_list[@]}

    # modify disk type info ==>  0:SSD  1:HDD
    for (( i=1;i < $disk_count; i++ )) do
        if [ ${disk_type_list[$i]} == "1" ]; then
            disk_type_list[$i]="HDD"
        else
            disk_type_list[$i]="SSD"
        fi
    done


    # create menu list
    for ((i=0 ;i < $disk_count; i++)) do
        if (( $i == 0 )) ;then
            continue
        fi
        local menu=`printf "%-10s%-10s%-10s" ${disk_name_list[$i]} ${size_list[$i]} ${disk_type_list[$i]} `
        choose_disk_menu_list[${#choose_disk_menu_list[@]}]="$menu"
    done

    ChooseMenu choose_disk_menu_list FormatDisk



}

Behind() {

    read -p "set local time is ShangHai? (Y/n):" input
    case $input in
        Y|y|"")
            rm -f /etc/localtime
            ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
            hwclock --systohc --localtime
            ;;
        *)
            ;;
    esac

    # @TODO hostname
    read -p "input hostname :" hostname
    echo $hostname > /etc/hostname

    # @TODO user and user pass
    read -s -p "root pass word :" root_pass
	echo "root:$root_pass" | chpasswd
    read -p "user name :" user_name
    useradd -m $user_name
    read -s -p "user pass word :" user_pass
    echo "$user_name:$user_pass" | chpasswd

    read -p "let user $user_name to admin?(Y/n)" sudo_user_flag
	case $sudo_user_flag in
		Y|y|"")
		echo "$user_name ALL=(ALL) ALL" >> /etc/sudoers
		;;
	esac



    echo "1.Grub"
    echo "2.Bios"
    echo "3.TODO"
    read -p "choose start type(default=1) :" input

    if [ $input -eq "1" ]; then
		YES | pacman -S grub efibootmgr
        read boot_loader_name
		grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=$boot_loader_name
		grub-mkconfig -o /boot/grub/grub.cfg            
    elif [ $input -eq "2" ]; then
		YES | pacman -Sy grub
		grub-install --target=i386-pc $disk_name
		grub-mkconfig -o /boot/grub/grub.cfg
    else
        echo "TODO"
    fi


    exit
    


}

if [ $# -eq 0 ]
then
    Front
else
    Behind

fi

