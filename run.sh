#!/bin/bash

# arg 1 = interface to run wifi network on (typically wlan0)
# arg 2 = interface to forward traffic to. This should have connection to the internet (typically eth0)
# arg 3 = SSID of created WiFi network




# hostapd config
echo -e "interface=$1\ndriver=nl80211\nssid=$3\nhw_mode=g\nchannel=6\nauth_algs=1\nwpa=0\nieee80211n=1" > /etc/hostapd/hostapd.conf


# dnsmasq config
echo -e "interface=$1\ndhcp-range=192.168.1.50,192.168.1.150,24h\ndhcp-option=3,192.168.1.1\ndhcp-option=6,192.168.1.1\nlog-queries\nlog-facility=/var/log/dnsmasq.log\n" > /etc/dnsmasq.conf
systemctl restart dnsmasq


add_line_if_not_exists() {
	local file="$1"
	local line="$2"
	
	if ! grep -Fxq "$line" "$file"; then
		echo "$line" >> "$file"
	fi
}

# make it so the www-data user can run sudo on iptables and arp
add_line_if_not_exists "/etc/sudoers" "www-data ALL=(ALL:ALL) NOPASSWD: /sbin/iptables, /usr/sbin/arp"

# change ownership of the password file so www-data can edit it
chown www-data:www-data /var/www/captive-portal/passwords.txt


#clear iptables rules
iptables -F
iptables -t nat -F
iptables -t mangle -F

# iptables rules to forward traffic to captive portal
iptables -t mangle -N captiveportal
iptables -t mangle -A PREROUTING -i $1 -p udp --dport 53 -j RETURN
iptables -t mangle -A PREROUTING -i $1 -j captiveportal
iptables -t mangle -A captiveportal -j MARK --set-mark 1
iptables -t nat -A PREROUTING -i $1  -p tcp -m mark --mark 1 -j DNAT --to-destination 192.168.1.1

# enable interface forwarding
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i $1 -j ACCEPT
iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE

# assign gateway address for WiFi interface
ifconfig $1 192.168.1.1 netmask 255.255.255.0 up

# modify nginx config to serve captive portal. This will overwrite existing default nginx config, so be sure to back it up
cp default.bak /etc/nginx/sites-available/default
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

systemctl restart php8.2-fpm
systemctl restart nginx

# launch the WiFi network with hostapd
hostapd /etc/hostapd/hostapd.conf
