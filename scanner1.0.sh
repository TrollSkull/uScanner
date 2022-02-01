#!/bin/bash

SOCIALMEDIA=(https://www.instagram.com/ https://www.facebook.com/)

read -p "Input Username: " USERNAME

for SOCIAL in "${SOCIALMEDIA[@]}"; do

	echo -n "Comprobando nombre de usuario ${USERNAME}..."
    check=$(curl -s "${SOCIAL}${USERNAME}" -L -H "Accept-Language: en" | grep -o 'This page is not available'; echo $?)

    if [[ $check == *'0'* ]]; then
        echo -e ${Y}"[-] ${W}uScanner: ${Y}Not Found!"

    else
        echo -e ${GRE}"[+] ${W}uScanner: ${GRE}Found! ${W}- ${SOCIAL}${USERNAME}"

    fi
done

echo "Script end."