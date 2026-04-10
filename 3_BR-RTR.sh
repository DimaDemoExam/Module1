# 3_BR-RTR.sh
en
conf t
hostname br-rtr.au-team.irpo
username net_admin
password P@ssw0rd
role admin
ntp timezone utc+3
ex
wr
conf t
int isp
# IP!!!
ip address 172.16.5.14/28
int lan
ip address 192.168.2.1/27
# IP!!!
port te0
service-instance isp
encapsulation untagged
connect ip interface isp
port te1
service-instance lan
encapsulation untagged
connect ip interface lan
ex
ex
# IP!!!
ip route 0.0.0.0/0 172.16.5.1
ip name-server 77.88.8.8
ip nat pool INTERNET 192.168.2.1-192.168.2.30
ip nat source dynamic inside-to-outside pool INTERNET overload 172.16.5.14
# IP!!!
int isp
ip nat outside
int lan
ip nat inside
ex
ex
wr
conf t
int tunnel.1
# IP!!!
ip address 10.10.10.10/30
ip tunnel 172.16.5.14 172.16.4.14 mode gre
# IP!!!
ex
ex
wr
conf t
router ospf 1
# IP!!!
network 10.10.10.8/30 area 0
network 192.168.2.0/27 area 0
# IP!!!
area 0 authentication message-digest
passive-interface isp
passive-interface lan
ex
int tunnel.1
ip ospf authentication-key P@ssw0rd
ip ospf authentication message-digest
ex
ex
wr
ex
