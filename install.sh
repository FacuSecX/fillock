#!/bin/bash


#Colors
white="\033[1;37m"
grey="\033[0;37m"
purple="\033[0;35m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
Purple="\033[0;35m"
Cyan="\033[0;36m"
Cafe="\033[0;33m"
Fiuscha="\033[0;35m"
blue="\033[1;34m"
nc="\e[0m"
clear



pkg update -y && pkg upgrade -y
clear
if which openssl >/dev/null; then
		sleep 0.25
         echo -e "$blue(AIRODUMP-NG)$nc .................................................. Instalado [$green✓$nc]"
else
		sleep 0.25
	 echo -e "$red(AIRODUMP-NG)$nc No instalado [$red✗$nc]"
			sleep 1
			pkg install install openssl -y && pkg install openssl-tool


fi



if which awk >/dev/null; then
		sleep 0.25
         echo -e "$blue(awk)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
else
		sleep 0.25
	 echo -e "$red(awk)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install awk -y
		
fi
if which gawk >/dev/null; then
		sleep 0.25
         echo -e "$blue(gawk)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
else
		sleep 0.25
	 echo -e "$red(gawk)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install gawk -y
		
fi

if which ruby >/dev/null; then
		sleep 0.25
         echo -e "$blue(ruby)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
	       gem install lolcat
else
		sleep 0.25
	 echo -e "$red(macchanger)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install ruby -y
	 gem install lolcat
		
fi

if which sed >/dev/null; then
		sleep 0.25
         echo -e "$blue(sed)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
	       
else
		sleep 0.25
	 echo -e "$red(sed)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install sed -y
		
fi
if which cowsay >/dev/null; then
		sleep 0.25
         echo -e "$blue(cowsay)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
	       
else
		sleep 0.25
	 echo -e "$red(cowsay)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install cowsay -y
		
fi

if which gem >/dev/null; then
		sleep 0.25
         echo -e "$blue(gem)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
	       
else
		sleep 0.25
	 echo -e "$red(gem)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install ruby -y
		
fi

if which figlet >/dev/null; then
		sleep 0.25
         echo -e "$blue(figlet)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
	       
else
		sleep 0.25
	 echo -e "$red(figlet)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install figlet -y
		
fi

if which mpv >/dev/null; then
		sleep 0.25
         echo -e "$blue(mpv)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
	       
else
		sleep 0.25
	 echo -e "$red(mpv)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install mpv -y
		
fi

if which shred >/dev/null; then
		sleep 0.25
         echo -e "$blue(shred)$nc ......................................................... Instalado [$green✓$nc]"
		sleep 0.25
	       
else
		sleep 0.25
	 echo -e "$red(shred)$nc  No instalado [$red✗$nc]"
			sleep 1
	 pkg install coreutils  -y
		
fi




clear
chmod +x fillock.sh
echo -e "iniciando programa en 5 segundos"
sleep 5
bash fillock.sh
