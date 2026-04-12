# START HQ_RTR!!!
# After HQ-SRV и HQ-CLI!!!
en
conf t
# SERVER IP!!!
ip name-server 192.168.1.2
ip domain-name au-team.irpo
ip domain-lookup
no ip name-server 77.88.8.8
# SERVER IP!!!
ex
wr
conf t
# DHCP SETTINGS!!!
ip pool hq 1
range 192.168.1.67-192.168.1.78
ex
dhcp-server 1
static ip 192.168.1.66
# MAC HQ-CLI!!!
client-id mac XX:XX:XX:XX:XX:XX
mask 255.255.255.240
gateway 192.168.1.65
dns 192.168.1.2
domain-search au-team.irpo
ex
pool hq 1
mask 255.255.255.240
gateway 192.168.1.65
dns 192.168.1.2
# DHCP SETTINGS!!!
domain-search au-team.irpo
int 200
dhcp-server 1
ex
ex
wr
ex
