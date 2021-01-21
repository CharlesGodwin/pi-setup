#!/bin/bash
#
# This file should not need editing, make changes in options.sh file
#
# The options file can be overriden at the command line
# i.e. /boot/initialize.sh /boot/<filename>
# default is /boot/initialize.sh /boot/options.sh

cd /boot
OPTIONS_FILE=$1
[ -z $OPTIONS_FILE ] && OPTIONS_FILE=/boot/options.sh
if [ ! -f "$OPTIONS_FILE" ]; then
    echo "Missing or invalid options file"
    exit 1
fi

function main(){
    sudo touch .initialize
    # cleanup crlf in $OPTIONS_FILE
    sudo sed -i 's/\r//' $OPTIONS_FILE
    echo "Options from $OPTIONS_FILE"
    source $OPTIONS_FILE
    set_password
    update
    [[ ( ! -z $GMAIL_AUTH && ! -z $GMAIL ) ]] && install_mail
    # rm -f /tmp/gmailsetup*
    command -v post_install >/dev/null 2>&1 && post_install
    echo "Initialization complete on $NEW_HOSTNAME"
    read -p "Press Enter key to reboot"
    sudo reboot
}

function set_password (){
    if [ -z "$NEW_PASSWORD" ]; then
        echo "Please change your password"
        passwd
    else
        printf "$NEW_PASSWORD\n$NEW_PASSWORD\n"|sudo passwd $USER
        # Strip password value
        sudo sed -i "/NEW_PASSWORD=/c\NEW_PASSWORD=" $OPTIONS_FILE
    fi
}

function update () {
    if [ ! -z "$LOCALE" ]; then
        echo "set locale $LOCALE"
        sudo sed -i "s/# $LOCALE/$LOCALE/g" /etc/locale.gen
        sudo locale-gen
    fi
    if [ ! -z "$TIMEZONE" ]; then
        echo "set timezone $TIMEZONE"
        sudo timedatectl set-timezone "$TIMEZONE"
    fi
    echo "Updating software"
    export DEBIAN_FRONTEND=noninteractive
    sudo apt update -qq
    sudo apt full-upgrade -y -qq
    sudo apt clean -y -qq
    [ -z "$PYTHON_MODULES" ] || INITIAL_PACKAGES="python3 python3-pip $INITIAL_PACKAGES"
    [[ ( ! -z $GMAIL_AUTH && ! -z $GMAIL ) ]] && INITIAL_PACKAGES="$INITIAL_PACKAGES exim4-daemon-light mailutils"
    if [ ! -z "$INITIAL_PACKAGES" ]; then
        echo "Installing initial packages"
        sudo apt install -yqq $INITIAL_PACKAGES
    fi
    sudo apt autoremove -y -qq
    if [ ! -z "$PYTHON_MODULES" ]; then
        echo "Installing Python3 modules $PYTHON_MODULES"
        sudo pip3 -q install $PYTHON_MODULES
    fi
    echo "Creating directories"
    [ -d ~/bin ] || mkdir ~/bin
    [ -d ~/.ssh ] || mkdir ~/.ssh
    chmod 700 ~/.ssh
    # cleanup Windows artifacts
    [ -d '/boot/System Volume Information' ] && sudo rm -Rf '/boot/System Volume Information'
    [ -d '/boot/$RECYCLE.BIN' ] && sudo rm -Rf '/boot/$RECYCLE.BIN'
    if [ ! -z "$NEW_HOSTNAME" ]; then
        sudo raspi-config nonint do_hostname $NEW_HOSTNAME
        sudo sed -i "s/$HOSTNAME/$NEW_HOSTNAME/g"  /etc/hosts
    else
        NEW_HOSTNAME=$HOSTNAME
    fi
}

function install_mail() {
    echo "Initializing mailer" 
    sudo touch /var/mail/$USER
    sudo chown $USER:mail /var/mail/$USER
    sudo chmod 660 /var/mail/$USER
    sudo sed -i  "s/GMAIL_AUTH/$GMAIL_AUTH/" /tmp/gmailsetup2.tmp 
    sudo sed -i  "s/GMAIL/$GMAIL/" /tmp/gmailsetup2.tmp 
    sudo mv /tmp/gmailsetup1.tmp /etc/exim4/update-exim4.conf.conf
    cat /etc/exim4/passwd.client /tmp/gmailsetup2.tmp > /tmp/gmailsetup3.tmp
    sudo mv /tmp/gmailsetup3.tmp /etc/exim4/passwd.client
    echo "root: $USER" | sudo tee -a /etc/aliases
    echo "restarting exim"
    sudo update-exim4.conf
    sudo systemctl restart exim4
    echo "$GMAIL">> ~/.forward
    echo "Testing email system"
    echo "This is a test email from $USER @ $HOSTNAME IP info `ifconfig`"|mail -s "Test email from $HOSTNAME" $GMAIL
    #  Let things settle down
    sleep 2
    sudo exim -qff
    echo "Output of email error log /var/log/exim4/mainlog"
    cat /var/log/exim4/mainlog
    echo "Gmail setup complete"
}
# 
#  preloaded files needed for email install
#
cat > /tmp/gmailsetup1.tmp <<INLINE
# /etc/exim4/update-exim4.conf.conf
dc_eximconfig_configtype='smarthost'
dc_other_hostnames=''
dc_local_interfaces='127.0.0.1 ; ::1'
dc_readhost=''
dc_relay_domains=''
dc_minimaldns='false'
dc_relay_nets=''
dc_smarthost='smtp.gmail.com::587'
CFILEMODE='644'
dc_use_split_config='false'
dc_hide_mailname='false'
dc_mailname_in_oh='true'
dc_localdelivery='mail_spool'
INLINE
cat > /tmp/gmailsetup2.tmp <<INLINE
gmail-smtp.l.google.com:GMAIL:GMAIL_AUTH
*.google.com:GMAIL:GMAIL_AUTH
smtp.gmail.com:GMAIL:GMAIL_AUTH
INLINE
#
#  only run once
#
[ -f .initialize ] || main
