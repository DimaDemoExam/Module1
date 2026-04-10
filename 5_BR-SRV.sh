# 5_BR-SRV.sh

#!/bin/bash
set -e
clear
hostnamectl hostname br-srv.au-team.irpo
timedatectl set-timezone Europe/Moscow
sed -i '1c\BOOTPROTO=static' /etc/net/ifaces/ens18/options
sed -i '4c\SYSTEMD_BOOTPROTO=static' /etc/net/ifaces/ens18/options


# SERVER NETWORK>

echo 192.168.2.2/27 > /etc/net/ifaces/ens18/ipv4address
echo default via 192.168.2.1 > /etc/net/ifaces/ens18/ipv4route
echo nameserver 77.88.8.8 > /etc/net/ifaces/ens18/resolv.conf

# <SERVER NETWORK


systemctl restart network
ping -c3 ya.ru
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
