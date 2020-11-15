#!/bin/bash
#
# If this is modified it MUST be saved with unix format LF, not Wundows CRLF
# or the script will fail
#set new password
echo "Please reset your password"
passwd
SOURCE=$1
[ -z $SOURCE ] && SOURCE=/boot/options.txt
#
# Cleanup up linefeeds in options file just in case
#
sudo sed -i 's/^M$//' $SOURCE
echo "Options from $SOURCE"
source $SOURCE
echo "set locale $LOCALE"
sudo sed -i "s/# $LOCALE/$LOCALE/g" /etc/locale.gen
sudo locale-gen
echo "set timezone $TIMEZONE"
sudo timedatectl set-timezone "$TIMEZONE"
echo "Updating software"
export DEBIAN_FRONTEND=noninteractive
sudo apt update -qq
sudo apt upgrade -y -qq
echo "Installing initial packages"
[ ! -z "$PYTHON_MODULES" ] && INITIAL_PACKAGES="python3 python3-pip $INITIAL_PACKAGES"
[ ! -z "$INITIAL_PACKAGES" ] && sudo apt install -yqq $INITIAL_PACKAGES
sudo apt autoremove -y -qq
echo "Installing base python3 modules"
[ ! -z "$PYTHON_MODULES" ] &&sudo pip3 -q install $PYTHON_MODULES
echo "Creating directories"
mkdir ~/bin
mkdir ~/.ssh
sudo rm -Rf /boot/'System Volume Information'
post_install
[[ ( ! -z $GMAIL_AUTH && ! -z $GMAIL ) ]] && echo "Be sure to run this next /boot/gmail-setup.sh $SOURCE"
sudo raspi-config nonint do_hostname $HOSTNAME
read -p "Initialization complete on $HOSTNAME, press any key to reboot"
sudo reboot
