#!/bin/sh

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

echo "${red}PN532 installer${reset}"
echo "${green}Installing dependencies${reset}"
sudo apt-get install -y libusb-dev libpcsclite-dev
echo "${green}Installed.${reset}"
if [ -d /home/pi/libnfc-1.7.1/ ]
then
    echo "${green}libnfc directory found."
    cd /home/pi/libnfc-1.7.1/
    echo "Starting configure.${reset}"
    ./configure --prefix=/usr --sysconfdir=/etc 
    echo "${green}Successfully configured."
    echo "Make started.${reset}"
    make
    sudo make install
    echo "${green}Succesfully maked the libnfc library.${reset}"
else
    echo "${green}libnfc directory not found."
    cd /home/pi/
    echo "${green}Downloading libnfc library.${reset}"
    wget http://dl.bintray.com/nfc-tools/sources/libnfc-1.7.1.tar.bz2
    echo "${green}libnfc library downloaded.${reset}"
    echo "${green}Unpacking libnfc library.${reset}"
    tar -xf libnfc-1.7.1.tar.bz2
    echo "${green}Unpaked libnfc library.${reset}"
    cd /home/pi/libnfc-1.7.1/
    echo "Starting configure.${reset}"
    ./configure --prefix=/usr --sysconfdir=/etc
    echo "${green}Successfully configured."
    echo "Make started.${reset}"
    make
    sudo make install
    echo "${green}Succesfully maked the libnfc library.${reset}"
fi

file="/etc/nfc/libnfc.conf"

if [ -d /etc/nfc ]
then
    echo "${green}NFC directory found.${reset}"
    echo "allow_autoscan = true">$file
    echo "allow_intrusive_scan = false">>$file
    echo "log_level = 1">>$file
    echo "device.name = \"Itead_PN532\"">>$file
    echo "device.connstring = \"pn532_i2c:/dev/i2c-1\"">>$file
    echo "${green}Configuration file created.${reset}"
else
    echo "${red}NFC directory not found.${reset}"
    echo "${green}Creating NFC directory.${reset}"
    mkdir /etc/nfc
    echo "${green}NFC directory created.${reset}"
    echo "allow_autoscan = true">$file
    echo "allow_intrusive_scan = false">>$file
    echo "log_level = 1">>$file
    echo "device.name = \"Itead_PN532\"">>$file
    echo "device.connstring = \"pn532_i2c:/dev/i2c-1\"">>$file
    echo "${green}Configuration file created.${reset}"
fi
