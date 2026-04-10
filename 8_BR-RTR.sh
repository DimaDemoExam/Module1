# 8_BR-RTR.sh
# AFTER HQ-SRV!!!
en
conf t
ip name-server 192.168.1.2
ip domain-name au-team.irpo
ip domain-lookup
no ip name-server 77.88.8.8
ex
wr
ping hq-srv
ex
