#!/bin/bash

# Name: uScanner (Username Scanner Tool)
# GitHub: https://github.com/TrollSkull/uScanner
# Version: v0.4-20211114

# Scanning up to 25 social networks!

trap 'echo "";stop_session;exit 1' 2
source $HOME/uScanner/core/variables.sh

function print_banner() {

    clear
    echo -e ${B}"       ____                                           "
    echo -e ${B}" __ __/ __/______ ____  ___  ___ ____                 " 
    echo -e ${B}"/ // /\ \/ __/ _  / _ \/ _ \/ -_) __/                 "
    echo -e ${B}"\_,_/___/\__/\_,_/_//_/_//_/\__/_/   ${W}v0.4-20211114"
    echo 
}

function stop_session() {

    # Function to stop uScanner session with CTRL+C.

    clear
    echo -e ${B}"       ____                                           "
    echo -e ${B}" __ __/ __/______ ____  ___  ___ ____                 " 
    echo -e ${B}"/ // /\ \/ __/ _  / _ \/ _ \/ -_) __/                 "
    echo -e ${B}"\_,_/___/\__/\_,_/_//_/_//_/\__/_/   ${W}v0.4-20211114"
    echo 
    echo -e ${GRE}"[+] ${W}uScanner: Session closed."
    echo
}

function save_file() {

    # Saving the .txt file in internal storage.

    source $HOME/uScanner/usernames/last_username.sh
    cd $HOME/uScanner/usernames

    if [[ -e $last_username.txt ]]; then
        mv ${last_username}.txt $EXTERNAL_STORAGE
        echo -e ${B}"[*] ${W}Saved:${B} ${last_username}.txt ${W}in${B} $EXTERNAL_STORAGE"
        echo
    fi

    exit
}

function removing_file() {

    # Removing the previous .txt file.

    if [[ -e $username.txt ]]; then
        rm -rf ${username}.txt
    fi

}

function check_wifi_connection() {

    # Checking WiFi connection.

    cd $HOME/uScanner/core
    python wifi.py
    source $HOME/uScanner/core/wifi_connection.sh

    if [ $wifi == "false" ]; then
        echo -e ${R}"[!] ${W}Please, check your internet connection."
        echo
        exit
    fi
    cd $HOME/uScanner/usernames
}

function change_last_username() {
    echo -e "#!/bin/bash" > $HOME/uScanner/usernames/last_username.sh
	echo -e "export last_username='${username}'" >> $HOME/uScanner/usernames/last_username.sh
}

function dependencies () {

    # Checking dependencies.

	if [ "${SYSTEM}" == "Android" ]; then
		if [ -x ${USR}/bin/curl ]; then
			PWD=$(pwd)
		else
			yes|pkg install curl
		fi
		if [ -x ${USR}/bin/uscanner ]; then
			PWD=$(pwd)
		else
			echo -e "#!/bin/bash" >> ${USR}/bin/uscanner
			echo -e "uScanner='${PWD}'" >> ${USR}/bin/uscanner
			echo -e 'cd ${uScanner}' >> ${USR}/bin/uscanner
			echo -e 'exec bash "${uScanner}/uscanner.sh" "$@"' >> ${USR}/bin/uscanner
			chmod 777 ${USR}/bin/uscanner
		fi
        if [ -x ${USR}/bin/python ]; then
            PWD=$(pwd)
        else
            yes|pkg install python
        fi
	else
		if [ -x /bin/curl ]; then
			PWD=$(pwd)
		else
			echo ""
			echo -e "Make you sure you have curl installed."
			exit
		fi
		if [ -x /bin/uscanner ]; then
			PWD=$(pwd)
		else
			echo -e "#!/bin/bash" >> /bin/uscanner
			echo -e "uScanner='${PWD}'" >> /bin/uscanner
			echo -e 'cd ${uScanner}' >> /bin/uscanner
			echo -e 'exec bash "${uScanner}/uscanner.sh" "$@"' >> /bin/uscanner
			chmod 777 /bin/uscanner
		fi
		if [ -x /bin/python ]; then
			PWD=$(pwd)
		else
			echo ""
			echo -e "Make you sure you have python installed."
			exit
		fi
	fi
}

dependencies

if [ -z "$1" ]; then

    # Without parameters.

    print_banner
    read -p "Input Username: " username
    clear

elif [ "$1" == "--help" ]||[ "$1" == "-h" ]; then

    # Help menu.

    print_banner
    echo "Usage: uscanner [username] or [-h] [-s] [-a] [-u]"
    echo
    echo "    -h, --help              Print this help menu"
    echo "    -s, --save              Save the .txt file in the storage"
    echo "    -a, --about             Print information about this program"
    echo "    -u, --update            Update this tool automatically"
    echo "        --uninstall         Uninstall the tool"
    echo
    echo "Report bugs to (t.me/TrollSkull)"
    echo
    exit

elif [ "$1" == "--save" ]||[ "$1" == "-s" ]; then

    # Save the .txt file in storage.

    print_banner
    save_file
    exit

elif [ "$1" == "--update" ]||[ "$1" == "-u" ]; then
    
    # Checking wifi connection.

    check_wifi_connection

    # Removing the old uScanner version.

    cd $HOME
    rm -rf "uScanner"

    # Cloning the new one.

    git clone https://github.com/TrollSkull/uScanner
    cd uScanner
    chmod 777 uscanner.sh
    print_banner
    echo -e ${GRE}"[+] uScanner: The tool has been successfully updated."
    exit

elif [ "$1" == "--about" ]||[ "$1" == "-a" ]; then

    # About the program.

    print_banner
    echo "Name:     uScanner"
    echo "Author:   TrollSkull"
    echo "Version:  v0.4-20211114"
    echo
    echo "Contact:   trollskull.contact@gmail.com"
    echo "Follow me: https://github.com/TrollSkull"
    echo
    exit

elif [ "$1" == "--uninstall" ]; then

    # Uninstall the tool.

    print_banner
    echo -e ${B}"[*] ${W}Uninstalling..."

    # Removing the uScanner launcher.

    cd ${USR}/bin
    rm -rf "uscanner"

    # Removing the uScanner folder.

    cd $HOME
    rm -rf "uScanner"

    echo -e ${GRE}"[+] ${W}uScanner has been uninstalled."
    echo
    exit
    
else
    # Help menu.

    print_banner
    echo "Usage: uscanner [username] or [-h] [-s] [-a] [-u]"
    echo
    echo "    -h, --help              Print this help menu"
    echo "    -s, --save              Save the .txt file in the storage"
    echo "    -a, --about             Print information about this program"
    echo "    -u, --update            Update this tool automatically"
    echo "        --uninstall         Uninstall the tool"
    echo
    echo "Report bugs to (t.me/TrollSkull)"
    echo
    exit
fi

function scan_username() {

    check_wifi_connection
    cd $HOME/uScanner/usernames
    change_last_username
    removing_file

    # Creating the .txt file and start scanning.

    echo "uScanner© username LOG file." > ${username}.txt
    echo " " >> ${username}.txt
    echo "[INFO] Scan taken on $DATE" >> ${username}.txt
    echo "[INFO] Username ${username} found on..." >> ${username}.txt
    echo " " >> ${username}.txt

    echo -e ${W}"[i] Press CTRL+C to stop session."
    echo -e ${B}"[*] ${W}Searching username${B} ${username} ${W}on..."

    echo

    # Checking Instagram username.

    check_instagram=$(curl -s "Accept-Language: en" "https://www.instagram.com/${username}" -L | grep -o 'Page not found'; echo $?)

    if [[ $check_instagram == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}Instagram: ${GRE}Found! ${W}- https://www.instagram.com/${username}"
        echo "[Instagram] https://www.instagram.com/${username}" >> ${username}.txt


    elif [[ $check_instagram == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Instagram: ${Y}Not Found!"

    fi

    # Checking Facebook username.

    check_facebook=$(curl -s "https://www.facebook.com/${username}" -L -H "Accept-Language: en" | grep -o 'This page is not available'; echo $?)

    if [[ $check_facebook == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}Facebook: ${GRE}Found! ${W}- https://www.facebook.com/${username}"
        echo "[Facebook] https://www.facebook.com/${username}" >> ${username}.txt

    elif [[ $check_facebook == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Facebook: ${Y}Not Found!"

    fi

    # Checking Twitter username. 

    check_twitter=$(curl -s "https://www.twitter.com/${username}" -L -H "Accept-Language: en" | grep -o 'This account does not exist'; echo $?)

    if [[ $check_twitter == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}Twitter: ${GRE}Found! ${W}- https://www.twitter.com/${username}"
        echo "[Twitter] https://www.twitter.com/${username}" >> ${username}.txt

    elif [[ $check_twitter == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Twitter: ${Y}Not Found!"

    fi

    # Checking YouTube username.

    check_youtube=$(curl -s "https://www.youtube.com/${username}" -L -H "Accept-Language: en" | grep -o '404 Not Found'; echo $?)

    if [[ $check_youtube == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}YouTube: ${GRE}Found! ${W}- https://www.youtube.com/${username}"
        echo "[YouTube] https://www.youtube.com/${username}" >> ${username}.txt

    elif [[ $check_youtube == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Youtube: ${Y}Not Found!"

    fi

    # Checking Reddit username.

    check_reddit=$(curl -s -i "https://www.reddit.com/user/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | head -n1 | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_reddit == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Reddit: ${GRE}Found! ${W}- https://www.reddit.com/${username}"
        echo "[Reddit] https://www.reddit.com/${username}" >> ${username}.txt

    elif [[ $check_reddit == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Reddit: ${Y}Not Found!"

    fi

    # Checking GitHub username.

    check_github=$(curl -s -i "https://www.github.com/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o '404 Not Found' ; echo $?)

    if [[ $check_github == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}GitHub: ${GRE}Found! ${W}- https://www.github.com/${username}"
        echo "[GitHub] https://www.github.com/${username}" >> ${username}.txt

    elif [[ $check_github == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}GitHub: ${Y}Not Found!"

    fi

    # Checking Steam username.

    check_steam=$(curl -s -i "https://steamcommunity.com/id/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o 'The specified profile could not be found' ; echo $?)

    if [[ $check_steam == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Steam: ${GRE}Found! ${W}- https://www.steamcommunity.com/id/${username}"
        echo "[Steam] https://www.steamcommunity.com/id/${username}" >> ${username}.txt

    elif [[ $check_steam1 == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Steam: ${Y}Not Found!"

    fi

    # Checking Pinterest username.

    check_pinterest=$(curl -s -i "https://www.pinterest.com/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o '?show_error' ; echo $?)

    if [[ $check_pinterest == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Pinterest: ${GRE}Found! ${W}- https://www.pinterest.com/${username}"
        echo "[Pinterest] https://www.pinterest.com/${username}" >> ${username}.txt

    elif [[ $check_pinterest == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Pinterest: ${Y}Not Found!"

    fi

    # Checking SoundCloud username.

    check_soundcloud=$(curl -s -i "https://soundcloud.com/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o '404 Not Found'; echo $?)

    if [[ $check_soundcloud == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}SoundCloud: ${GRE}Found! ${W}- https://www.soundcloud.com/${username}"
        echo "[SoundCloud] https://www.soundcloud.com/${username}" >> ${username}.txt

    elif [[ $check_soundcloud == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}SoundCloud: ${Y}Not Found!"

    fi

    # Checking Spotify username.

    check_spotify=$(curl -s -i "https://open.spotify.com/user/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_spotify == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Spotify: ${GRE}Found! ${W}- https://open.spotify.com/user/${username}"
        echo "[Spotify] https://open.spotify.com/user/${username}" >> ${username}.txt

    elif [[ $check_spotify == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Spotify: ${Y}Not Found!"

    fi

    # Checking DevianArt username.

    check_devianart=$(curl -s -i "https://$username.deviantart.com" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_devianart == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}DevianArt: ${GRE}Found! ${W}- https://$username.deviantart.com"
        echo "[DevianArt] https://$username.deviantart.com" >> ${username}.txt

    elif [[ $check_devianart == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}DevianArt: ${Y}Not Found!"

    fi

    # Checking Badoo username.

    check_badoo=$(curl -s -i "https://www.badoo.com/en/$username" -H "Accept-Language: en" -L | grep -o '404 Not Found' ; echo $?)

    if [[ $check_badoo == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Badoo: ${GRE}Found! ${W}- https://www.badoo.com/en/$username"
        echo "[Badoo] https://www.badoo.com/en/$username" >> ${username}.txt

    elif [[ $check_badoo == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Badoo: ${Y}Not Found!"

    fi

    # Checking Patreon username.

    check_patreon=$(curl -s -i "https://www.patreon.com/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_patreon == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Patreon: ${GRE}Found! ${W}- https://www.patreon.com/$username"
        echo "[Patreon] https://www.patreon.com/$username" >> ${username}.txt

    elif [[ $check_patreon == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Patreon: ${Y}Not Found!"

    fi

    # Checking Kongregate username.

    check_kongregate=$(curl -s -i "https://kongregate.com/accounts/$username" -H "Accept-Language: en" -L | grep -o '404 Not Found' ; echo $?)

    if [[ $check_kongregate == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Kongregate: ${GRE}Found! ${W}- https://kongregate.com/accounts/$username"
        echo "[Kongregate] https://kongregate.com/accounts/$username" >> ${username}.txt

    elif [[ $check_kongregate == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Kongregate: ${Y}Not Found!"

    fi

    # Checking Pastebin username.

    check_pastebin=$(curl -s -i "https://pastebin.com/u/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o 'location: /index' ; echo $?)

    if [[ $check_pastebin == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Pastebin: ${GRE}Found! ${W}- https://pastebin.com/u/$username"
        echo "[Pastebin] https://pastebin.com/u/$username" >> ${username}.txt

    elif [[ $check_pastebin == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Pastebin: ${Y}Not Found!"

    fi

    # Checking Roblox username.

    check_roblox=$(curl -s -i "https://www.roblox.com/user.aspx?username=$username" -H "Accept-Language: en" -L | grep -o '404 Not Found' ; echo $?)

    if [[ $check_roblox == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Roblox: ${GRE}Found! ${W}- https://www.roblox.com/user.aspx?username=$username"
        echo "[Roblox] https://www.roblox.com/user.aspx?username=$username" >> ${username}.txt

    elif [[ $check_roblox == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Roblox: ${Y}Not Found!"

    fi

    # Checking Newgrounds username.

    check_newgrounds=$(curl -s -i "https://$username.newgrounds.com" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404 ' ; echo $?)

    if [[ $check_newgrounds == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Newgrounds: ${GRE}Found! ${W}- https://$username.newgrounds.com"
        echo "[Newgrounds] https://$username.newgrounds.com" >> ${username}.txt

    elif [[ $check_newgrounds == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Newgrounds: ${Y}Not Found!"

    fi

    # Checking Wattpad username.

    check_wattpad=$(curl -s -i "https://www.wattpad.com/user/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404 ' ; echo $?)

    if [[ $check_wattpad == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Wattpad: ${GRE}Found! ${W}- https://www.wattpad.com/user/$username"
        echo "[Wattpad] https://www.wattpad.com/user/$username" >> ${username}.txt

    elif [[ $check_wattpad == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Wattpad: ${Y}Not Found!"

    fi

    # Checking Canva username.

    check_canva=$(curl -s -i "https://www.canva.com/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404 ' ; echo $?)

    if [[ $check_canva == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Canva: ${GRE}Found! ${W}- https://www.canva.com/$username"
        echo "[Canva] https://www.canva.com/$username" >> ${username}.txt

    elif [[ $check_canva == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Canva: ${Y}Not Found!"

    fi

    # Checking Wikipedia username.

    check_wikipedia=$(curl -s -i "https://www.wikipedia.org/wiki/User:$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_wikipedia == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Wikipedia: ${GRE}Found! ${W}- https://www.wikipedia.org/wiki/User:$username"
        echo "[Wikipedia] https://www.wikipedia.org/wiki/User:$username" >> ${username}.txt

    elif [[ $check_wikipedia == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Wikipedia: ${Y}Not Found!"

    fi

    # Checking Ebay username.

    check_ebay=$(curl -s -i "https://www.ebay.com/usr/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404\|404 Not Found\|eBay Profile - error' ; echo $?)

    if [[ $check_ebay == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Ebay: ${GRE}Found! ${W}- https://www.ebay.com/usr/$username"
        echo "[Ebay] https://www.ebay.com/usr/$username" >> ${username}.txt

    elif [[ $check_ebay == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Ebay: ${Y}Not Found!"

    fi

    # Checking Codecademy username.

    check_codecademy=$(curl -s -i "https://www.codecademy.com/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_codecademy == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Codecademy: ${GRE}Found! ${W}- https://www.codecademy.com/$username"
        echo "[Codecademy] https://www.codecademy.com/$username" >> ${username}.txt

    elif [[ $check_codecademy == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Codecademy: ${Y}Not Found!"

    fi

    # Checking BitBucket username.

    check_bitbucket=$(curl -s -i "https://bitbucket.org/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_bitbucket == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}BitBucket: ${GRE}Found! ${W}- https://bitbucket.org/$username"
        echo "[BitBucket] https://bitbucket.org/$username" >> ${username}.txt

    elif [[ $check_bitbucket == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}BitBucket: ${Y}Not Found!"

    fi

    # Checking MixCloud username.

    check_mixcloud=$(curl -s -i "https://www.mixcloud.com/$username" -H "Accept-Language: en" -L | grep -o 'error-message' ; echo $?)

    if [[ $check_mixcloud == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}MixCloud: ${GRE}Found! ${W}- https://www.mixcloud.com/$username"
        echo "[MixCloud] https://www.mixcloud.com/$username" >> ${username}.txt

    elif [[ $check_mixcloud == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}MixCloud: ${Y}Not Found!"

    fi

    echo " " >> ${username}.txt
    echo "GPL-3.0 License © uScanner" >> ${username}.txt
    echo -e ${W}""
}

print_banner
scan_username

# GPL-3.0 License © uScanner
# Original Creator - TrollSkull
