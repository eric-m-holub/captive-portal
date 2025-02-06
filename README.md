# Captive Portal
Malicious captive portal to steal credentials and spy on user traffic
![portal](lockportal_login.png)


## Setup
This repo is intended for Kali Linux. Clone it into /var/www and then run:

`sudo bash install.sh`

That will install the necessary dependencies.

I ran this with an ALFA AWUS1900 Wi-Fi Adapter. You'll want to install the Kali drivers for it and then plug it in prior to running. I wrote a blog post that includes setup for this device. Link [here](https://www.ericholub.com/blog/wifi-deauth/)

## Running
Run:

`sudo bash run.sh <wifi interface> <internet interface> <ssid name>`

That will start the captive portal with nginx and the Wi-Fi network with hostapd. The Wi-Fi interface will likely be 'wlan0' and the internet interface will be 'eth0'. Yours may be different depending on the setup of your machine.

## Use
The Wi-Fi network will redirect Windows, iOS, and Android traffic to the captive portal screen upon connection. They will then be prompted to enter in credentials for popular third party sign ins. The first login attempt will fail by default (to discourage people from entering anything in), but the second will succeed. Each login attempt, whether successful or not will be logged in the 'passwords.txt' file.

This repo took inspiration from s0meguy1's RougeWifi repo. Link [here](https://github.com/s0meguy1/RougeWifi)
