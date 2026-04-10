#!/bin/bash
set -e
clear
hostnamectl hostname hq-srv.au-team.irpo
hostnamectl
timedatectl set-timezone Europe/Moscow
sed -i '1c\BOOTPROTO=static' /etc/net/ifaces/ens18/options
sed -i '4c\SYSTEMD_BOOTPROTO=static' /etc/net/ifaces/ens18/options


# SERVER NETWORK>

echo 192.168.1.2/26 > /etc/net/ifaces/ens18/ipv4address
echo default via 192.168.1.1 > /etc/net/ifaces/ens18/ipv4route
echo nameserver 77.88.8.8 > /etc/net/ifaces/ens18/resolv.conf

# <SERVER NETWORK


systemctl restart network
apt-get update
apt-get install -y bind bind-utils
useradd -m sshuser -u 2026 -s /bin/bash
passwd sshuser
usermod -aG wheel sshuser
sed -i '100c\WHEEL_USERS ALL=(ALL:sshuser) NOPASSWD: ALL' /etc/sudoers
sed -i '13c\Port 2026' /etc/openssh/sshd_config
sed -i '30c\AllowUsers sshuser' /etc/openssh/sshd_config
sed -i '34c\MaxAuthTries 2' /etc/openssh/sshd_config
sed -i '105c\Banner /etc/banner.net' /etc/openssh/sshd_config
touch /etc/banner.net
echo Authorized access only! > /etc/banner.net
sed -i '1a\ ' /etc/openssh/sshd_config
systemctl restart sshd.service
ssh -p 2026 sshuser@localhost
sed -i '6c\#include "/etc/bind/rndc.conf";' /etc/bind/named.conf


# SERVER BIND IP

sed -i '16c\\tlisten-on { 192.168.1.2; };' /etc/bind/options.conf


sed -i '17c\\t//listen-on-v6 { ::1; };' /etc/bind/options.conf
sed -i '24c\\tforwarders { 77.88.8.8; };' /etc/bind/options.conf
sed -i '29c\\tallow-query { any; };' /etc/bind/options.conf
sed -i '40c\\tallow-query-cache { any; };' /etc/bind/options.conf
sed -i '49c\\tallow-recursion { any; };' /etc/bind/options.conf
sed -i '7a\ ' /etc/bind/local.conf
sed -i '8c\zone "au-team.irpo" {' /etc/bind/local.conf
sed -i '8a\ ' /etc/bind/local.conf
sed -i '9c\    type master;' /etc/bind/local.conf
sed -i '9a\ ' /etc/bind/local.conf
sed -i '10c\    file "/etc/bind/zone/db.au";' /etc/bind/local.conf
sed -i '10a\ ' /etc/bind/local.conf
sed -i '11c\};' /etc/bind/local.conf
sed -i '11a\ ' /etc/bind/local.conf
sed -i '12c\zone "1.168.192.in-addr.arpa" {' /etc/bind/local.conf
sed -i '12a\ ' /etc/bind/local.conf
sed -i '13c\    type master;' /etc/bind/local.conf
sed -i '13a\ ' /etc/bind/local.conf
sed -i '14c\    file "/etc/bind/zone/db.revers";' /etc/bind/local.conf
sed -i '14a\ ' /etc/bind/local.conf
sed -i '15c\};' /etc/bind/local.conf
sed -i '15a\ ' /etc/bind/local.conf
cd /etc/bind/zone
cp localhost db.au
sed -i '2c\@\tIN\tSOA\tau-team.irpo. root.au-team.irpo. (' db.au
sed -i '9c\\tIN\tNS\tau-team.irpo.' db.au


# SERVER db.au IP

sed -i '10c\\tIN\tA\t192.168.1.2' db.au


cp db.au db.revers
chown root:named db.*


# ALL NETWORK IPs>

sed -i '10a\ ' db.au
sed -i '11c\hq-srv\tIN\tA\t192.168.1.2' db.au
sed -i '11a\ ' db.au
sed -i '12c\hq-rtr\tIN\tA\t192.168.1.1' db.au
sed -i '12a\ ' db.au
sed -i '13c\br-srv\tIN\tA\t192.168.2.2' db.au
sed -i '13a\ ' db.au
sed -i '14c\br-rtr\tIN\tA\t192.168.2.1' db.au
sed -i '14a\ ' db.au
sed -i '15c\hq-cli\tIN\tA\t192.168.1.66' db.au
sed -i '15a\ ' db.au
sed -i '16c\docker\tIN\tCNAME\thq-rtr' db.au
sed -i '16a\ ' db.au
sed -i '17c\web\tIN\tCNAME\tbr-rtr' db.au
sed -i '17a\ ' db.au
sed -i '10a\ ' db.revers
sed -i '11c\1\tIN\tPTR\thq-rtr.au-team.irpo.' db.revers
sed -i '11a\ ' db.revers
sed -i '12c\2\tIN\tPTR\thq-srv.au-team.irpo.' db.revers
sed -i '12a\ ' db.revers
sed -i '13c\66\tIN\tPTR\thq-cli.au-team.irpo.' db.revers

# <ALL NETWORK IPs


sed -i '13a\ ' db.revers
cd /etc/bind/zone/
systemctl restart network
systemctl restart bind
named-checkzone au-team.irpo db.au


# SERVER named-checkzone IP

named-checkzone 1.168.192.in-addr.arpa db.revers

# SERVER NETWORK IP

sed -i '1c\nameserver 192.168.1.2' /etc/net/ifaces/ens18/resolv.conf


sed -i '1a\ ' /etc/net/ifaces/ens18/resolv.conf
sed -i '2c\search au-team.irpo' /etc/net/ifaces/ens18/resolv.conf
systemctl restart network
systemctl restart bind
host hq-srv


# SERVER NETWORK IP

host 192.168.1.2


host web
host ya.ru
