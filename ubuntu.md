__Setup Pi with Ubuntu__

__Ubuntu uses a deployment methodology named Cloud Init. If all you are deploying is Ubuntu images I strongly recommend you use their technology instead. Refer to this for details. https://cloudinit.readthedocs.io/__

**This has been tested with 32bit and 64bit Ubuntu 20.10 server.**

Ubuntu initializes and starts differently than Raspberry OS.

- SSH support is the default so do not copy the `ssh` file to the boot folder.
- Wireless setup is not done with wpa_supplicant.conf so do not copy `wpa_supplicant.conf`.
- If you want to have wireless WiFi you need to edit a file  named `network-config`. Refer to these documents for detailed setup information.
https://cloudinit.readthedocs.io/en/latest/topics/network-config.html
https://cloudinit.readthedocs.io/en/latest/topics/network-config-format-v2.html
https://netplan.io/reference
https://linuxconfig.org/ubuntu-20-04-connect-to-wifi-from-command-line
- The initial boot takes several minutes to complete, even when using an SSD drive. Be patient.
- The default user:password is ubuntu:ubuntu. When you first login you will be forced to change your password and then the system will automatically disconnect. You must login again.
- Once you login the files you placed in the boot folder on your PC will be in `/boot/firmware`, not `/boot`, so start the process with `/boot/firmware/initialize.sh`
