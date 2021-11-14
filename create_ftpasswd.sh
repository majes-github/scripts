#!/bin/sh

PASSWD_FILE=/daten/docker/secrets/proftpd.passwd
HOME_DEFAULT=/daten/upload

if [ $# -lt 2 ]; then
    echo "Usage: $0 <user_name> <password> [home_dir]"
    exit 1
fi
user="$1"
passwd="$2"
home="$3"

if [ $(id -u) -ne 0 ]; then
    echo 'This script requires root privileges. Try again with "sudo".'
    exit 2
fi

# create ftp users and directories
if [ ! -e $PASSWD_FILE ]; then
    touch $PASSWD_FILE
    chown root: $PASSWD_FILE
fi

hash=$(busybox mkpasswd -m md5 $passwd)
if grep "^$1:" $PASSWD_FILE >/dev/null; then
    # user already exists
    if [ -z "$home" ]; then
	# do not change homedir
	home=$(awk -F: '{ print $6 }' $PASSWD_FILE)
    fi
    sed -i "/^$1:/s|^\($1:\).*\(:.*:.*::\).*\(:.*\)|\1$hash\2$home\3|" $PASSWD_FILE
else
    if [ -z "$home" ]; then
	# use default for homedir
	home=$HOME_DEFAULT
    fi
    id=$((6001 + $(wc -l < $PASSWD_FILE)))
    echo "$user:$hash:$id:$id::$home:/bin/false" >> $PASSWD_FILE
fi
