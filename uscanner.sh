#!/bin/bash

trap 'echo "", ctrl_c, exit 1' 2
source $(pwd)/lib/utils.sh; MAIN="MAIN"

function print_banner() {
    clear
    echo -e ${B}"       ____                                  "
    echo -e ${B}" __ __/ __/______ ____  ___  ___ ____        " 
    echo -e ${B}"/ // /\ \/ __/ _  / _ \/ _ \/ -_) __/        "
    echo -e ${B}"\_,_/___/\__/\_,_/_//_/_//_/\__/_/   ${W}v1.0"
    echo 
}

function ctrl_c () {
    print_banner
    echo -e ${Y}"[uScanner] ${W}Keyboard interrupt detected, exiting."; exit
}

function create_logfile() {
    echo "uScanner username LOG file." > ${USERNAME}.txt
    echo " " >> ${USERNAME}.txt
    echo "[INFO] Scan taken on $DATE" >> ${USERNAME}.txt
    echo "[INFO] Username ${USERNAME} found on..." >> ${USERNAME}.txt
    echo " " >> ${USERNAME}.txt
}

function scan_username() {
    create_logfile; print_banner
    
    SOCIALMEDIA=(instagram facebook youtube twitter github codecademy pinterest soundcloud patreon canva bitbucket mixcloud)
    declare -i FOUND=0

    echo -e ${B}"[uScanner] ${W}Searching username ${B}${USERNAME}${W} on..."; echo

    for SOCIAL in "${SOCIALMEDIA[@]}"; do
       
        CHECK=$(curl -s "https://www.${SOCIAL}.com/${USERNAME}" -L -H "Accept-Language: en" | grep -owie '404 Not Found' -owie 'Page not found' -owie 'This page is not available' -owie 'This account does not exist' -owie 'HTTP/2 404'; echo $?)
        echo -ne "Checking https://www.${SOCIAL}.com/${USERNAME}... "

        if [[ $CHECK == *'0'* ]]; then
            echo -e ${Y}"[Not Found!]${W}"

        else
            echo -e ${GRE}"[Found!]${W}"
            FOUND=$FOUND+1
            
            echo "[Found!] https://www.${SOCIAL}.com/${USERNAME}" >> ${USERNAME}.txt
        fi

    done

    echo
    echo -e ${B}"[uScanner] ${W}Username ${GRE}${USERNAME}${W} found on ${GRE}${FOUND}${W} pages."
}

function main() {
    cd $HERE/lib; python3 wifi.py
    source $HERE/lib/wifi.sh

    if [ $wifi == "false" ]; then

        print_banner
        echo -e ${R}"[uScanner] ${W}Please, check your internet connection."
        echo; exit

    fi; cd $HERE/usernames; scan_username
}

if [ -z "$1" ]; then

    print_banner
    echo -ne ${GRE}"[uScanner] ${W}Input username: "; read USERNAME
    clear

elif [ "$1" == "--help" ]||[ "$1" == "-h" ]; then

    print_banner
    echo -e ${W}"Usage: ./uscanner.sh [username] or [-h] [-a] [-u]"
    echo
    echo -e ${C}"    -h, --help              ${W}Print this help menu"
    echo -e ${C}"    -a, --about             ${W}Print information about this program"
    echo -e ${C}"    -u, --update            ${W}Update this tool automatically"
    echo -e ${C}"        --uninstall         ${W}Uninstall the tool"
    echo
    echo -e ${W}"Report bugs to (t.me/TrollSkull)"
    echo; exit


elif [ "$1" == "--update" ]||[ "$1" == "-u" ]; then

    print_banner
    echo -e ${B}"[uScanner] ${W}Updating tool..."

    cd $HERE; cd ..
    rm -rf "$HERE"

    git clone https://github.com/TrollSkull/uScanner &> /dev/null
    cd $HERE; chmod 777 uscanner.sh

    print_banner
    echo -e ${GRE}"[uScanner] ${W}The tool has been successfully updated."; exit

elif [ "$1" == "--about" ]||[ "$1" == "-a" ]; then

    print_banner
    echo -e ${GRE}"Name:     ${W}uScanner"
    echo -e ${GRE}"Author:   ${W}TrollSkull"
    echo -e ${GRE}"Version:  ${W}v1.0"
    echo
    echo -e ${GRE}"Follow me: ${W}https://github.com/TrollSkull"
    echo; exit

elif [ "$1" == "--uninstall" ]; then

    print_banner
    echo -e ${B}"[uScanner] ${W}Uninstalling..."
    
    rm -rf "$HERE"

    echo -e ${GRE}"[uScanner] ${W}The tool has been uninstalled."; exit
    
else
    USERNAME=$1
fi

if [ "$MAIN" == "MAIN" ]; then
    main
fi
