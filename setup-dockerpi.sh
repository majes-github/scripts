#!/bin/bash

# use data partition
sudo mkdir /daten
echo -e "LABEL=daten\t/daten\t\text4\tdefaults\t0\t1" | sudo tee -a /etc/fstab

# raspios adjustments
echo -e 'dtoverlay=disable-wifi\ndtoverlay=disable-bt' | sudo tee -a  /boot/config.txt
sudo raspi-config nonint do_hostname dockerpi
sudo raspi-config nonint do_memory_split 16
sudo raspi-config nonint do_change_locale de_DE.UTF-8
sudo raspi-config nonint do_change_timezone Europe/Berlin

# packages
sudo apt update && sudo apt upgrade -y
curl -sSL https://get.docker.com | sudo sh
sudo usermod -aG docker pi
#sudo apt install -y docker-compose git screen tcpdump vim
sudo apt install -y git screen tcpdump vim
