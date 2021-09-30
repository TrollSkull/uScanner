#!/bin/bash

# Name: uScanner (Username Scanner Tool)
# GitHub: https://github.com/TrollSkull/uScanner
# Version: v0.1-20210930

# Scanning up to 20 social networks!

trap 'echo "";print_banner;exit 1' 2

# Variables and routes.

PWD=$(pwd)
SYSTEM=$(uname -o)
HOME="/data/data/com.termux/files/home"
USR="/data/data/com.termux/files/usr"

# Colors.

R='\033[31m'
GRE='\033[32m'
W='\033[37m'
B='\033[34m'
GRA='\033[1;30m'
Y='\033[1;33m'
C='\033[1;36m'

function print_banner() {

    clear
    echo -e ${B}"       ____                                           "
    echo -e ${B}" __ __/ __/______ ____  ___  ___ ____                 " 
    echo -e ${B}"/ // /\ \/ __/ _  / _ \/ _ \/ -_) __/                 "
    echo -e ${B}"\_,_/___/\__/\_,_/_//_/_//_/\__/_/   ${W}v0.1-20210930"
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
	else
		if [ -x /bin/curl ]; then
			PWD=$(pwd)
		else
			echo ""
			echo -e "Make you sure you have curl installed."
			exit
		fi
		if [ -x /bin/uscan ]; then
			PWD=$(pwd)
		else
			echo -e "#!/bin/bash" >> /bin/uscanner
			echo -e "uScanner='${PWD}'" >> /bin/uscanner
			echo -e 'cd ${uScanner}' >> /bin/uscanner
			echo -e 'exec bash "${uScanner}/uscanner.sh" "$@"' >> /bin/uscanner
			chmod 777 /bin/uscanner
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
    echo "Usage: uscanner [username] or [-h] [-s] [-a]"
    echo
    echo "    -h, --help              Print this help menu"
    echo "    -s, --save              Save the .txt file in the storage"
    echo "    -a, --about             Print information about this program"
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

elif [ "$1" == "--uninstall" ]; then

    # Uninstall the tool.

    print_banner
    echo -e ${B}"[*] ${W}Uninstalling..."
    echo

    # Removing the uScanner launcher.

    cd ${USR}/bin
    rm -rf "uscanner"

    # Removing the uScanner folder.

    cd $HOME
    rm -rf "uScanner"

    echo -e ${GRE}"[+] ${W}uScanner has been uninstalled."
    echo
    exit
    
elif [ "$1" == "--about" ]||[ "$1" == "-a" ]; then

    # sobre el programa

    print_banner
    echo "Name:     uScanner"
    echo "Author:   TrollSkull"
    echo "Version:  v0.1-20210930"
    echo
    echo "Contact:   trollskull.contact@gmail.com"
    echo "Follow me: https://github.com/TrollSkull"
    echo
    exit

else
    username=$1
fi

function scan_username() {

    cd $HOME/uScanner/usernames
    change_last_username
    removing_file

    echo -e ${B}"[*] ${W}Searching username${B} ${username} ${W}on..."
    echo

    # Checking Instagram username.

    check_instagram=$(curl -s "Accept-Language: en" "https://www.instagram.com/${username}" -L | grep -o 'Page not found'; echo $?)

    if [[ $check_instagram == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}Instagram: ${GRE}Found! ${W}- https://www.instagram.com/${username}"
        echo "https://www.instagram.com/${username}" >> ${username}.txt


    elif [[ $check_instagram == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Instagram: ${Y}Not Found!"

    fi

    # Checking Facebook username.

    check_facebook=$(curl -s "https://www.facebook.com/${username}" -L -H "Accept-Language: en" | grep -o 'This page is not available'; echo $?)

    if [[ $check_facebook == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}Facebook: ${GRE}Found! ${W}- https://www.facebook.com/${username}"
        echo "https://www.facebook.com/${username}" >> ${username}.txt

    elif [[ $check_facebook == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Facebook: ${Y}Not Found!"

    fi

    # Checking Twitter username. 

    check_twitter=$(curl -s "https://www.twitter.com/${username}" -L -H "Accept-Language: en" | grep -o 'This account does not exist'; echo $?)

    if [[ $check_twitter == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}Twitter: ${GRE}Found! ${W}- https://www.twitter.com/${username}"
        echo "https://www.twitter.com/${username}" >> ${username}.txt

    elif [[ $check_twitter == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Twitter: ${Y}Not Found!"

    fi

    # Checking YouTube username.

    check_youtube=$(curl -s "https://www.youtube.com/${username}" -L -H "Accept-Language: en" | grep -o '404 Not Found'; echo $?)

    if [[ $check_youtube == *'1'* ]]; then
        echo -e ${GRE}"[+] ${W}YouTube: ${GRE}Found! ${W}- https://www.youtube.com/${username}"
        echo "https://www.youtube.com/${username}" >> ${username}.txt

    elif [[ $check_youtube == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}Youtube: ${Y}Not Found!"

    fi

    # Checking Reddit username.

    check_reddit=$(curl -s -i "https://www.reddit.com/user/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | head -n1 | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_reddit == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Reddit: ${GRE}Found! ${W}- https://www.reddit.com/${username}"
        echo "https://www.reddit.com/${username}" >> ${username}.txt

    elif [[ $check_reddit == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Reddit: ${Y}Not Found!"

    fi

    # Checking GitHub username.

    check_github=$(curl -s -i "https://www.github.com/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o '404 Not Found' ; echo $?)

    if [[ $check_github == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}GitHub: ${GRE}Found! ${W}- https://www.github.com/${username}"
        echo "https://www.github.com/${username}" >> ${username}.txt

    elif [[ $check_github == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}GitHub: ${Y}Not Found!"

    fi

    # Checking Steam username.

    check_steam=$(curl -s -i "https://steamcommunity.com/id/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o 'The specified profile could not be found' ; echo $?)

    if [[ $check_steam == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Steam: ${GRE}Found! ${W}- https://www.steamcommunity.com/id/${username}"
        echo "https://www.steamcommunity.com/id/${username}" >> ${username}.txt

    elif [[ $check_steam1 == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Steam: ${Y}Not Found!"

    fi

    # Checking Pinterest username.

    check_pinterest=$(curl -s -i "https://www.pinterest.com/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o '?show_error' ; echo $?)

    if [[ $check_pinterest == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Pinterest: ${GRE}Found! ${W}- https://www.pinterest.com/${username}"
        echo "https://www.pinterest.com/${username}" >> ${username}.txt

    elif [[ $check_pinterest == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Pinterest: ${Y}Not Found!"

    fi

    # Checking SoundCloud username.

    check_soundcloud=$(curl -s -i "https://soundcloud.com/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o '404 Not Found'; echo $?)

    if [[ $check_soundcloud == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}SoundCloud: ${GRE}Found! ${W}- https://www.soundcloud.com/${username}"
        echo "https://www.soundcloud.com/${username}" >> ${username}.txt

    elif [[ $check_soundcloud == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}SoundCloud: ${Y}Not Found!"

    fi

    # Checking Spotify username.

    check_spotify=$(curl -s -i "https://open.spotify.com/user/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_spotify == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Spotify: ${GRE}Found! ${W}- https://open.spotify.com/user/${username}"
        echo "https://open.spotify.com/user/${username}" >> ${username}.txt

    elif [[ $check_spotify == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Spotify: ${Y}Not Found!"

    fi

    # Checking DevianArt username.

    check_devianart=$(curl -s -i "https://$username.deviantart.com" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_devianart == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}DevianArt: ${GRE}Found! ${W}- https://$username.deviantart.com"
        echo "https://$username.deviantart.com" >> ${username}.txt

    elif [[ $check_devianart == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}DevianArt: ${Y}Not Found!"

    fi

    # Checking Badoo username.

    check_badoo=$(curl -s -i "https://www.badoo.com/en/$username" -H "Accept-Language: en" -L | grep -o '404 Not Found' ; echo $?)

    if [[ $check_badoo == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Badoo: ${GRE}Found! ${W}- https://www.badoo.com/en/$username"
        echo "https://www.badoo.com/en/$username" >> ${username}.txt

    elif [[ $check_badoo == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Badoo: ${Y}Not Found!"

    fi

    # Checking Patreon username.

    check_patreon=$(curl -s -i "https://www.patreon.com/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404' ; echo $?)

    if [[ $check_patreon == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Patreon: ${GRE}Found! ${W}- https://www.patreon.com/$username"
        echo "https://www.patreon.com/$username" >> ${username}.txt

    elif [[ $check_patreon == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Patreon: ${Y}Not Found!"

    fi

    # Checking Kongregate username.

    check_kongregate=$(curl -s -i "https://kongregate.com/accounts/$username" -H "Accept-Language: en" -L | grep -o '404 Not Found' ; echo $?)

    if [[ $check_kongregate == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Kongregate: ${GRE}Found! ${W}- https://kongregate.com/accounts/$username"
        echo "https://kongregate.com/accounts/$username" >> ${username}.txt

    elif [[ $check_kongregate == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Kongregate: ${Y}Not Found!"

    fi

    # Checking Pastebin username.

    check_pastebin=$(curl -s -i "https://pastebin.com/u/$username" -H "Accept-Language: en" -L --user-agent '"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:0.9.3) Gecko/20010801"' | grep -o 'location: /index' ; echo $?)

    if [[ $check_pastebin == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Pastebin: ${GRE}Found! ${W}- https://pastebin.com/u/$username"
        echo "https://pastebin.com/u/$username" >> ${username}.txt

    elif [[ $check_pastebin == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Pastebin: ${Y}Not Found!"

    fi

    # Checking Roblox username.

    check_roblox=$(curl -s -i "https://www.roblox.com/user.aspx?username=$username" -H "Accept-Language: en" -L | grep -o '404 Not Found' ; echo $?)

    if [[ $check_roblox == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Roblox: ${GRE}Found! ${W}- https://www.roblox.com/user.aspx?username=$username"
        echo "https://www.roblox.com/user.aspx?username=$username" >> ${username}.txt

    elif [[ $check_roblox == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Roblox: ${Y}Not Found!"

    fi

    # Checking Newgrounds username.

    check_newgrounds=$(curl -s -i "https://$username.newgrounds.com" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404 ' ; echo $?)

    if [[ $check_newgrounds == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Newgrounds: ${GRE}Found! ${W}- https://$username.newgrounds.com"
        echo "https://$username.newgrounds.com" >> ${username}.txt

    elif [[ $check_newgrounds == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Newgrounds: ${Y}Not Found!"

    fi

    # Checking Wattpad username.

    check_wattpad=$(curl -s -i "https://www.wattpad.com/user/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404 ' ; echo $?)

    if [[ $check_wattpad == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Wattpad: ${GRE}Found! ${W}- https://www.wattpad.com/user/$username"
        echo "https://www.wattpad.com/user/$username" >> ${username}.txt

    elif [[ $check_wattpad == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Wattpad: ${Y}Not Found!"

    fi

    # Checking Canva username.

    check_canva=$(curl -s -i "https://www.canva.com/$username" -H "Accept-Language: en" -L | grep -o 'HTTP/2 404 ' ; echo $?)

    if [[ $check1 == *'1'* ]] ; then 
        echo -e ${GRE}"[+] ${W}Canva: ${GRE}Found! ${W}- https://www.canva.com/$username"
        echo "https://www.canva.com/$username" >> ${username}.txt

    elif [[ $check1 == *'0'* ]]; then 
        echo -e ${Y}"[-] ${W}Canva: ${Y}Not Found!"

    fi

    echo -e ${W}""
}

print_banner
scan_username

# GPL-3.0 License © uScanner
# Original Creator - TrollSkull
