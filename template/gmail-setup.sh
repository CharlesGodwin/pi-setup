#!/bin/bash
#
SOURCE=$1
[ -z $SOURCE ] && SOURCE=/boot/options.txt
#
# Cleanup up linefeeds in options file just in case
#
sudo sed -i 's/^M$//' $SOURCE
echo "Options from $SOURCE"
source $SOURCE
echo "Installing and initializing mailer"
sudo apt install -yqq exim4-daemon-light mailutils
sudo touch /var/mail/$USER
sudo chown $USER:mail /var/mail/$USER
sudo chmod 660 /var/mail/$USER
cat <<INLINE | sudo tee /etc/exim4/update-exim4.conf.conf
# /etc/exim4/update-exim4.conf.conf
#
# Edit this file and /etc/mailname by hand and execute update-exim4.conf
# yourself or use 'dpkg-reconfigure exim4-config'
#
# Please note that this is _not_ a dpkg-conffile and that automatic changes
# to this file might happen. The code handling this will honor your local
# changes, so this is usually fine, but will break local schemes that mess
# around with multiple versions of the file.
#
# update-exim4.conf uses this file to determine variable values to generate
# exim configuration macros for the configuration file.
#
# Most settings found in here do have corresponding questions in the
# Debconf configuration, but not all of them.
#
# This is a Debian specific file

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
sudo echo "root: $USER" | sudo tee -a /etc/aliases
cat <<INLINE | sudo tee -a /etc/exim4/passwd.client
gmail-smtp.l.google.com:$GMAIL:$GMAIL_AUTH
*.google.com:$GMAIL:$GMAIL_AUTH
smtp.gmail.com:$GMAIL:$GMAIL_AUTH
INLINE
echo "restarting exim"
sudo update-exim4.conf
sudo systemctl restart exim4
echo "$GMAIL">> ~/.forward
echo "Testing email system"
echo "This is a test email from $HOSTNAME @ `hostname -I`"|mail -s "Test email from $HOSTNAME" $GMAIL
sudo exim -qff
echo "Setup complete"
