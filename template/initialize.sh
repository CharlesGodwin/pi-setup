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
sudo apt update -qq
sudo apt upgrade -yqq
echo "Installing initial packages"
sudo apt install -yqq $INITIAL_PACKAGES
sudo apt autoremove -yqq
echo "Installing base python3 modules"
sudo pip3 -q install $PYTHON_MODULES
git config --global credential.helper store
git config --global user.email $GIT_EMAIL
git config --global user.name "$GIT_NAME"
echo "Creating directories"
mkdir ~/bin
mkdir ~/.ssh
sudo rm -Rf /boot/'System Volume Information'
if [ -f "$EXTRA_SCRIPT" ]
then
  echo "Running extra script $EXTRA_SCRIPT"
  bash $EXTRA_SCRIPT
fi
read -p "Initialization complete on $HOSTNAME, press any key to reboot"
sudo raspi-config nonint do_hostname $HOSTNAME
sudo reboot
