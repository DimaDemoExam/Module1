en
conf t
hostname hq-rtr.au-team.irpo
username net_admin
password P@ssw0rd
role admin
ntp timezone utc+3
ex
wr
conf t
int isp
# IP!!!
ip address 172.16.4.14/28
int 100
ip address 192.168.1.1/26
int 200
ip address 192.168.1.65/28
int 999
ip address 192.168.1.81/29
# IP!!!
port te0
service-instance isp
encapsulation untagged
connect ip interface isp
port te1
service-instance 100
encapsulation dot1q 100
rewrite pop 1
connect ip interface 100
ex
service-instance 200
encapsulation dot1q 200
rewrite pop 1
connect ip interface 200
ex
service-instance 999
encapsulation dot1q 999
rewrite pop 1
connect ip interface 999
ex
ex
# IP!!!
ip route 0.0.0.0/0 172.16.4.1
ip name-server 77.88.8.8
ip nat pool INTERNET 192.168.1.1-192.168.1.87
ip nat source dynamic inside-to-outside pool INTERNET overload 172.16.4.14
# IP!!!
int isp
ip nat outside
ex
int 100
ip nat inside
ex
int 200
ip nat inside
ex
int 999
ip nat inside
ex
ex
wr
conf t
int tunnel.1
# IP!!!
ip address 10.10.10.9/30
ip tunnel 172.16.4.14 172.16.5.14 mode gre
# IP!!!
ex
ex
wr
conf t
router ospf 1
# IP!!!
network 10.10.10.8/30 area 0
network 192.168.1.0/26 area 0
network 192.168.1.64/28 area 0
network 192.168.1.80/29 area 0
# IP!!!
passive-interface isp
passive-interface 100
passive-interface 200
passive-interface 999
area 0 authentication message-digest
ex
int tunnel.1
ip ospf authentication-key P@ssw0rd
ip ospf authentication message-digest
ex
ex
wr
ex
