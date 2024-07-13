source ./head.sh

YES() {
    yes ""
}

FormatDisk() {

    disk_name=${disk_name_list[(($cur_choose_menu+1))]}
    echo "$disk_name"
    disk_type=${disk_type_list[(($cur_choose_menu+1))]}

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
    case "input" in
        Y|y|"")
            rm -f /etc/localtime
            ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
            hwclock --systohc --localtime
            ;;
        *)
            ;;
    esac

    # @TODO hostname
    echo Arch > /etc/hostname

    # @TODO user and user pass
    echo "root:$root_pass" | chpasswd

    useradd -m $user_name
    echo "$user_name:$user_pass" | chpasswd
    echo "$user_name ALL=(ALL) ALL" >> /etc/sudoers

    exit




}

if [ $# -eq 0 ]
then
    Front
else
    Behind

fi
