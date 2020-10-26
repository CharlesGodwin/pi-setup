__Set up Pi__

I have been configuring a lot of Pi images and every time I create a new image I do the same thngs over and over again. This became tiresome and error prone.

This project consists of initialization scripts and support files to allow for a routine setup of a new Pi image.

I prefer this type of install instead of keeping a duplicate image of an existing system. Those images grow out of date and take a lot of disk storage on my PC.

This provides an optional second step to set up use of Google gmail as the outbound email handler. If you use something else, or don't want mail support,  don't run the second step.

The files will do the following:

1. Cause the image to boot supporting ssh and log into your local WiFi connection.

2. initialize.sh
   1. force password change
   2. set up locale
   3. set up timezone
   4. update software
   5. Installs initial packages
   6. Installs initial python3 packages
   7. change hostname
   8. reboot
3. gmail-setup.sh
   1. Install exim4 mailer and mail client
   2.  Initializes exim4 mailer for gmail
   3.  Assign forwarding of emails for root and pi to gmail
   4.  Sends test email

Follow these steps to a simple new image. I say simple, but it is not quick, as a lot of updates and installs take place.

1. Create a Pi boot image on SD, USB or SSD using your favourite imager. I use the Raspberry Pi Imager https://www.raspberrypi.org/downloads/
2. After creation, remount the image in your machine
3. Copy the contents of the templates directory to the root directory on the image
4. __In the root directory,__ edit `wpa_supplicant.conf` file for your country code, SSID and WiFi password
5. __In the root directory,__ edit `options.txt` file.  There are six values:
   1. HOSTNAME= add the hostname you ant for your new Pi system. It must be unique in your network
   2. LOCALE= locale for your location. Default is `en_US.UTF-8` To find out what you have used before, log into a running Pi terminal and type `locale -a`
   3. TIMEZONE= timezone string for your location. refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones To find out what you have used before log into a running Pi terminal and type `timedatectl status`
   4. INITIAL_PACKAGES= initial packages you want installed for your system. The provided list is just my opinion of what is essential. Opinions will vary. They are `git python3-pip zip dos2unix` Depending on the Pi image you use, some of these packages may already be installed.
   5. GMAIL settings are only needed if you want to install gmail support
   6. GMAIL= your gmail email address
   7. GMAIL_AUTH= the authorization string you got from google for applications to use your account. Refer to https://myaccount.google.com/permissions
6. Eject the device from your machine
7. Insert device in new Pi and apply power
8. Determine address of new machine and connect using ssh or just try `ssh pi@raspberrypi` or `ssh pi@raspberrypi.local`. You can also connect directly using a keyboard and monitor.
9. Once logged in ,run `/boot/initialize.sh`
10. Wait - this can take a long time
11. The machine will reboot when finished
12. If you don't want gmail support on your system then you are finished
13. After reboot connect again
14. run `/boot/gmail-setup.sh`


When finished, remove these three files from /boot/ directory
1.  options.txt
2.  initialize.sh
3.  gmail-setup.sh

**NOTE** A second script is needed to install gmail support as a reboot is needed when hostname is changed.
