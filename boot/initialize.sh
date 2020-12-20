#!/bin/bash
#
# If this is modified it MUST be saved with unix format LF, not Windows CRLF
# or the script will fail
NEW_HOSTNAME=
LOCALE="en_US.UTF-8"
# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
TIMEZONE=
INITIAL_PACKAGES="python3 python3-pip zip"
PYTHON_MODULES=
function post_install () {
    # add custom post install bash code see README.md
}
#set new password
echo "Please reset your password"
passwd
if [ ! -z "$LOCALE"]; then
    echo "set locale $LOCALE"
    sudo sed -i "s/# $LOCALE/$LOCALE/g" /etc/locale.gen
    sudo locale-gen
fi
if [ ! -z "$TIMEZONE"]; then
    echo "set timezone $TIMEZONE"
    sudo timedatectl set-timezone "$TIMEZONE"
fi
echo "Updating software"
export DEBIAN_FRONTEND=noninteractive
sudo apt update -qq
sudo apt full-upgrade -y -qq
echo "Installing initial packages"
[ -z "$PYTHON_MODULES" ] || INITIAL_PACKAGES="python3 python3-pip $INITIAL_PACKAGES"
[ -z "$INITIAL_PACKAGES" ] || sudo apt install -yqq $INITIAL_PACKAGES
sudo apt autoremove -y -qq
if [ ! -z "$PYTHON_MODULES" ]; then
    echo "Installing python3 modules $PYTHON_MODULES"
    sudo pip3 -q install $PYTHON_MODULES
fi
echo "Creating directories"
[ -d ~/bin ] || mkdir ~/bin
[ -d ~/.ssh ] || mkdir ~/.ssh
[ -d /boot/'System Volume Information' ] && sudo rm -Rf /boot/'System Volume Information'
post_install
[ -f /boot/gmail-setup.sh ] && echo "Be sure to immediately run '/boot/gmail-setup.sh' for mail suport"
if [ -z "$NEW_HOSTNAME" ]; then
  echo "Initialization complete on $HOSTNAME"
else
    sudo raspi-config nonint do_hostname $NEW_HOSTNAME
    read -p "Initialization complete on $NEW_HOSTNAME, press any key to reboot"
    sudo reboot
fi
