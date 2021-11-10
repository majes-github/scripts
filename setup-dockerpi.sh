#!/bin/sh

# use data partition
sudo mkdir /daten
echo -e "LABEL=daten\t/daten\t\text4\tdefaults\t0\t1" | sudo tee -a /etc/fstab

# raspios adjustments
echo -e 'dtoverlay=disable-wifi\ndtoverlay=disable-bt' | sudo tee -a  /boot/config.txt
sudo raspi-config nonint do_hostname dockerpi
sudo raspi-config nonint do_memory_split 16
sudo raspi-config nonint do_change_locale de_DE.UTF-8
sudo raspi-config nonint do_change_timezone Europe/Berlin
mkdir -p ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGRzAkPqFQAhytGHR2BWKY8Nq+U8QZk03EnXHJqRlX8VpEOVgR30t4maeegnuHPZuHK9a6zh10dtT7s5AyibR3d85fU3DtU6Zw0Y8QOuGwSe9vVY9I1m7RZmdcNTQqcINtxhOyD/mxM8TD9YS9f0A8IAxFhcT+UMKscROkE0WvwIA2KzsA2TIKTv8hM0SiEfUIwFkXEuZwlR/lVQMytWRicLuvGvW5nZCGYhjm/BhvKIDE6mA5zGfB4LelF1KJT5yhy7El39zxk39z9Xmr1zXvdyV7AQ3EZX70V6zUZQljUTrf3JpRDlObsDGWQXDIOHBkszutnrNEctn6O6hgS11t mj@mini.nr.majes.de" > ~/.ssh/authorized_keys

# packages
sudo apt update && sudo apt upgrade -y
curl -sSL https://get.docker.com | sudo sh
sudo usermod -aG docker pi
sudo apt install -y docker-compose git screen tcpdump vim
