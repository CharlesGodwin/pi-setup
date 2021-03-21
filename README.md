__Set up Pi__

**This is intended for experienced users who wants to streamline the initial setup of a Raspberry Pi.**

**If you plan to use this with a Ubuntu image, please read the companion document ubuntu.md**

This has been written for a Windows audience but users of Mac or Linux machines should be able use these instructions with minimal modification.
This assumes:

- You are comfortable using ssh/bash terminal on a Raspberry Pi
- You know how to build a Raspberry Pi boot image
- If you choose to use GMAIL mail support you know how to get an authorization key from Google.

I have been configuring a lot of Pi images and every time I create a new image I do the same things, over and over again. This became tiresome and error prone.

This project consists of initialization scripts to allow for a routine setup of a new Pi image.

I prefer this type of install instead of keeping a duplicate image of an existing system. Those images grow out of date and take a lot of disk storage on my PC.

This provides an optional step to set up use of Google gmail as the outbound email handler. If you provide gmail credentials a mail transfer agent will be installed to use gmail.

This has been provided as a template so you can create your own repository just by clicking on the `Use this template`  Refer to https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template. Alternatively you can download the files as a zip file.


The scripts will do the following:

1. Cause the image to boot supporting ssh and log into your local WiFi connection.

2. initialize.sh
   1. Force password change
   2. Set up locale
   3. Set up timezone
   4. Update software
   5. Installs initial packages if needed
   6. Installs initial python3 packages if needed
   7. Run any optional extra setup steps
   8. If gMail credentials are provided:
      1.  Install exim4 mailer and mail client
      2.  Initializes exim4 mailer for gmail
      3.  Assign forwarding of emails for root and pi to gmail
      4.  Sends test email
   9.  Change hostname
   10. Reboot


Follow these steps to a simple new image. I say simple, but it is not quick, as a lot of updates and installs take place.

1. Create a Pi boot image on SD, USB or SSD using your favourite imager. I use the Raspberry Pi Imager https://www.raspberrypi.org/downloads/
2. After creation, remount the image in your machine. In Windows, just remove and insert the device.
3. __In the ./boot directory,__ edit `wpa_supplicant.conf` file for your country code, SSID and WiFi password
4. __In the ./boot directory,__ edit `options.sh` file.  There are many values:
   1. NEW_HOSTNAME= The hostname you want for your new Pi system. It must be unique in your network
   2. LOCALE= The locale for your location. Default is `en_US.UTF-8` To find out what you have used before, log into a running Pi terminal and type `locale -a`
   3. KEYBOARD= Set to alternate keyboard. Default is 'uk', American is 'us'. refer to http://xfree86.org/current/XKBproto.pdf
   4. TIMEZONE= timezone string for your location. refer to https://en.wikipedia.org/wiki/List_of_tz_database_time_zones To find out what you have used before log into a running Pi terminal and type `timedatectl status`
   5. INITIAL_PACKAGES= initial packages you want installed for your system. The provided list is just my opinion of what is essential. Opinions will vary. They are `python3-pip zip dos2unix`. Depending on the Pi image you use, some of these packages may already be installed.
   6. post_install shell function. This function is called from initialize.sh at end of the setup and can contain any additional code you want to run as part of setup. I use this to set unusual settings and add an entry to `~/.bash_aliases`.
   7. AUTO_RESTART= If this is set to `yes` then the script will automatically reboot when it is completed without waiting for user input.
   8. If you want to install gmail support:
      1. GMAIL= your gmail email address
      2. GMAIL_AUTH= the authorization string you got from google for applications to use your account. Refer to https://myaccount.google.com/permissions
5. Copy the contents of the `./boot` directory to the `boot` partition on the image.
6. Eject the device from your machine
7. Insert device in a new Pi and apply power
8. Determine address of new machine and connect using ssh or just try `ssh pi@raspberrypi` or `ssh pi@raspberrypi.local`. You can also connect directly using a keyboard and monitor.
9. Once logged in, run `/boot/initialize.sh <options.sh>` The options filename parameter is only necessary if you use a different name for your options.
10. You will be prompted to change the default password.
11. Then wait as it updates the software - this can take a long time
12. The machine will pause and reboot when finished

Consider using a ssh key for access. https://www.raspberrypi.org/documentation/remote-access/ssh/passwordless.md

<pre>
pi-setup
├── README.md
├── ubuntu.md
└── boot
    ├── initialize.sh
    ├── options.sh
    ├── ssh
    └── wpa_supplicant.conf
</pre>
