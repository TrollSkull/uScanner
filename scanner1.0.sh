#!/bin/bash

# Name: uScanner (Username Scanner Tool)
# GitHub: https://github.com/TrollSkull/uScanner
# Version: v1.0-scan_test

# Scanning up to 25 social networks!

SOCIALMEDIA=(https://www.instagram.com/ https://www.facebook.com/ https://youtube.com/)
declare -i FOUND=0

read -p "Input Username: " USERNAME

echo "Checking username ${USERNAME}..."

for SOCIAL in "${SOCIALMEDIA[@]}"; do

    check=$(curl -s "${SOCIAL}${USERNAME}" -L -H "Accept-Language: en" | grep -o '404 Not Found'; echo $?)

    if [[ $check == *'0'* ]]; then
        echo "[-] uScanner: Not Found!"

    else
        echo "[+] uScanner: Found! - ${SOCIAL}${USERNAME}"
        FOUND=$FOUND+1

    fi
done

echo "[*] Username ${USERNAME} found on ${FOUND} pages.