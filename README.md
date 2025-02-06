# Captive Portal
Malicious captive portal to steal credentials and spy on user traffic
![portal](lockportal_login.png)


## Setup
This repo is intended for Kali Linux. Clone it into /var/www/ with:

`sudo git clone https://github.com/eric-m-holub/captive-portal.git /var/www/captive-portal`

To install dependencies run:

`sudo bash install.sh`

I use an ALFA AWUS1900 Wi-Fi Adapter to broadcast the Wi-Fi network. You'll want to install the Kali drivers for it and then plug it in prior to running. I wrote a blog post that includes setup for this device. Link [here](https://www.ericholub.com/blog/wifi-deauth/).

## Running
Run:

`sudo bash run.sh <wifi interface> <internet interface> <ssid name>`

That will start the Wi-Fi network with the given SSID. The Wi-Fi interface will likely be 'wlan0' and the internet interface will be 'eth0'. Yours may be different depending on the setup of your machine.

## Use
The Wi-Fi network will redirect Windows, iOS, and Android traffic to the captive portal screen upon connection. They will then be prompted to enter in credentials for popular third party sign ins. Internet access is restricted until this info is entered. The first login attempt will fail by default (to discourage people from entering random credentials), but the second will succeed. Each login attempt, whether successful or not, will be logged in the 'passwords.txt' file.

Once users are signed in, DNS queries made on the Wi-Fi network will be logged in /var/log/dnsmasq.log. You can view it with:

`sudo cat /var/log/dnsmasq.log`

HTTP traffic can be sniffed with WireShark (installed in Kali by default). Just be sure to specify your Wi-Fi interface before capturing
![wireshark](https://github.com/user-attachments/assets/9198860f-c343-4db1-b2f8-7be1e71c0f6f)


## Acknowledgements
This repo took inspiration from s0meguy1's RougeWifi repo. Link [here](https://github.com/s0meguy1/RougeWifi)
