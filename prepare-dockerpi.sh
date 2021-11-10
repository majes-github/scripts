#!/bin/sh

image=$(ls -1tr *raspios*.img 2>&- | head -1)
base_device=sda
device=/dev/$base_device

if [ "$image" = "" ]; then
  echo "No RaspiOS image found in current directory. Abort."
  exit 1
fi

if [ ! -b $device ]; then
  echo "Device $device does not exist. Abort."
  exit 2
fi

echo "Overwriting device with image."
echo " * Device: $device (size = $(awk '$4 == "'$base_device'"{ printf("%d GiB", $3 / 1024 / 1024) }' /proc/partitions))"
echo " * Image:  $image"
echo -n "Continue? [yN] "
read yn
if [ "$yn" != "y" -a "$yn" != "Y" ]; then
  echo "Abort."
  exit 3
fi

which pv >/dev/null || { sudo apt update && sudo apt install -y pv; }
pv $image | sudo dd of=$device bs=1M
sleep 3
echo ",32G"  | sudo sfdisk $device -N 2
echo "32G,+" | sudo sfdisk $device --append

sudo mount ${device}1 /mnt
sudo touch /mnt/ssh
sudo umount /mnt

sudo mount ${device}2 /mnt
sudo mkdir -p /mnt/home/pi/.ssh
sudo sh -c 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGRzAkPqFQAhytGHR2BWKY8Nq+U8QZk03EnXHJqRlX8VpEOVgR30t4maeegnuHPZuHK9a6zh10dtT7s5AyibR3d85fU3DtU6Zw0Y8QOuGwSe9vVY9I1m7RZmdcNTQqcINtxhOyD/mxM8TD9YS9f0A8IAxFhcT+UMKscROkE0WvwIA2KzsA2TIKTv8hM0SiEfUIwFkXEuZwlR/lVQMytWRicLuvGvW5nZCGYhjm/BhvKIDE6mA5zGfB4LelF1KJT5yhy7El39zxk39z9Xmr1zXvdyV7AQ3EZX70V6zUZQljUTrf3JpRDlObsDGWQXDIOHBkszutnrNEctn6O6hgS11t mj@mini.nr.majes.de" > /mnt/home/pi/.ssh/authorized_keys'
sudo chown -R 1000:1000 /mnt/home/pi/.ssh
sudo umount /mnt
