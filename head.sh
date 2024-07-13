
HideCursour() {
    echo -en "\e[?25l"
}
ShowCursour() {
    echo -en "\e[?25h"
}

SetColor() {
    echo -en "\e[32m"
}
ClearColor(){
    echo -en "\e[39m"
}


ChooseMenu() {

    HideCursour
    cur_choose_menu=0
    local -n menu_list=$1
    call_back=$2
    while true; do

    	clear
        local tab=""
        menu_count=$((${#menu_list[@]}))
        for (( i=0; i<$menu_count; i++ )); do

            if (( $i == $cur_choose_menu )); then
                tab='=> '
            else
                tab='   '
            fi        

            SetColor
            printf "%-4s" $tab
            ClearColor
            echo "${menu_list[$i]}"

        done

        read -n1 -s op
        case "${op}" in
            A) # up
                cur_choose_menu=$cur_choose_menu-1
            ;;
            B) # down
                cur_choose_menu=$cur_choose_menu+1
            ;;
            D) # left
                echo "left"
            ;;
            C) # right
                echo "right"
            ;;
            "") # enter
                $call_back
                break
            ;;
            *)   
            ;;
        esac
        cur_choose_menu=$(( ((cur_choose_menu+$menu_count)) % $menu_count))
            
    done


}
