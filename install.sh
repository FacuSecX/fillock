#!/bin/bash

# Colors
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
nc="\e[0m"

clear

echo -e "${yellow}Actualizando Termux...${nc}"
pkg update -y && pkg upgrade -y
clear

# 🔹 función instalación
check_install () {

    if which $1 >/dev/null 2>&1; then
        echo -e "$blue($1)$nc .................................... Instalado [$green✓$nc]"
    else
        echo -e "$red($1)$nc .................................... No instalado [$red✗$nc]"
        pkg install -y $2
    fi
}

# 🔥 DEPENDENCIAS PRINCIPALES (SCRIPT V2)
check_install openssl "openssl openssl-tool"
check_install awk "awk"
check_install gawk "gawk"
check_install sed "sed"
check_install find "findutils"
check_install tar "tar"
check_install gzip "gzip"
check_install pv "pv"
check_install stat "coreutils"
check_install shred "coreutils"

# 🔹 EXTRAS VISUALES (opcionales pero usados)
check_install ruby "ruby"
check_install figlet "figlet"
check_install cowsay "cowsay"
check_install mpv "mpv"
check_install exiftool "exiftool"

# 🔹 lolcat
if which gem >/dev/null 2>&1; then
    gem install lolcat >/dev/null 2>&1
fi

clear

chmod +x fillock.sh

echo -e "${green}Iniciando Fillock...${nc}"
sleep 3

bash fillock.sh
