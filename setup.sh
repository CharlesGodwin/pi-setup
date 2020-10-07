cat startup.txt
cd ~/pi-setup
chmod +x *.sh
sudo apt install -y python3 python3-pip zip dos2unix docker docker-compose mailtools exim4
#
sudo pip3 install -r requirements.txt
#
# https://raspinotes.wordpress.com/2019/03/10/send-email-from-raspberrypi-with-exim4/
#
cat clientinfo.txt
read -p "Copy indicated lines above and add to end of file about to be edited"
sudo dpkg-reconfigure exim4-config
echo "use clientinfo.txt"
sudo nano /etc/exim4/passwd.client
sudo update-exim4.conf
sudo service exim4 restart
echo "charles@godwin.ca">> ~/.forward
echo "This is a test email"|mail -s "Test email" charles@godwin.ca
