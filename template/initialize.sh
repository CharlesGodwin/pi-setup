#!/bin/bash
#
# If this is modified it MUST be saved with unix format LF, not Wundows CRLF
# or the script will fail
#
# Cleanup up linefeeds in options.txt just in case
#
sudo sed -i 's/^M$//' /boot/options.txt
#set new password
echo "Please reset your password"
passwd
SOURCE=$1
if [ -z $SOURCE ]
then
  SOURCE=/boot/options.txt
fi
echo "Options from $SOURCE"
source $SOURCE
echo "set locale $LOCALE"
sudo sed -i "s/# $LOCALE/$LOCALE/g" /etc/locale.gen
sudo locale-gen
echo "set timezone $TIMEZONE"
sudo timedatectl set-timezone "$TIMEZONE"
echo "Updating software"
sudo apt update
sudo apt upgrade -y
echo "Installing initial packages"
sudo apt install -y $INITIAL_PACKAGES
sudo apt autoremove -y
echo "Installing base python3 modules"
sudo pip3 install $PYTHON_MODULES
git config --global credential.helper store
git config --global user.email $GIT_EMAIL
git config --global user.name "$GIT_NAME"
echo "Creating directories"
mkdir ~/bin
mkdir ~/.ssh
sudo rm -Rf /boot/'System Volume Information'
sudo raspi-config nonint do_hostname $HOSTNAME
read -p "Initialization complete on $HOSTNAME, press any key to reboot"
sudo reboot
