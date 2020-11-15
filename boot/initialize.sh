#!/bin/bash
#
# If this is modified it MUST be saved with unix format LF, not Wundows CRLF
# or the script will fail
NEW_HOSTNAME=
LOCALE="en_US.UTF-8"
TIMEZONE=
INITIAL_PACKAGES="python3 python3-pip zip"
PYTHON_MODULES=
post_install () {
    # add post install bash code see README.md
}
#set new password
echo "Please reset your password"
passwd
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
[ ! -z "$PYTHON_MODULES" ] && sudo pip3 -q install $PYTHON_MODULES
echo "Creating directories"
mkdir ~/bin
mkdir ~/.ssh
sudo rm -Rf /boot/'System Volume Information'
post_install
echo "Be sure to run this next /boot/gmail-setup.sh if you want mail suport"
if [ ! -z "$NEW_HOSTNAME" ]; then
    sudo raspi-config nonint do_hostname $NEW_HOSTNAME
    read -p "Initialization complete on $NEW_HOSTNAME, press any key to reboot"
    sudo reboot
else
    echo "Initialization complete on $HOSTNAME"
fi
