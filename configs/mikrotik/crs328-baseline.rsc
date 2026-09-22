# 2026-09-06 23:33:01 by RouterOS 7.24.2
# software id = 0JUG-TNFT
#
# model = CRS328-24P-4S+
# serial number = A1A10A78FCB6
/interface bridge
add admin-mac=74:4D:28:34:D3:10 auto-mac=no comment=defconf name=BridgeMain
/interface vlan
add interface=BridgeMain name=VlanCTF vlan-id=30
add interface=BridgeMain name=VlanEdu vlan-id=20
add interface=BridgeMain name=VlanMng vlan-id=10
/interface list
add name=lan
/ip pool
add name=PoolMng ranges=10.0.10.10-10.0.10.100
add name=PoolEdu ranges=10.0.20.10-10.0.20.100
add name=PoolCTF ranges=10.0.30.10-10.0.30.100
/interface bridge port
add bridge=BridgeMain comment=defconf interface=ether3
add bridge=BridgeMain comment=defconf interface=ether4
add bridge=BridgeMain comment=defconf interface=ether5
add bridge=BridgeMain comment=defconf interface=ether6
add bridge=BridgeMain comment=defconf interface=ether7
add bridge=BridgeMain comment=defconf interface=ether8
add bridge=BridgeMain comment=defconf interface=ether9
add bridge=BridgeMain comment=defconf interface=ether10
add bridge=BridgeMain comment=defconf interface=ether11
add bridge=BridgeMain comment=defconf interface=ether12
add bridge=BridgeMain comment=defconf interface=ether13
add bridge=BridgeMain comment=defconf interface=ether14
add bridge=BridgeMain comment=defconf interface=ether15
add bridge=BridgeMain comment=defconf interface=ether16
add bridge=BridgeMain comment=defconf interface=ether17
add bridge=BridgeMain comment=defconf interface=ether18
add bridge=BridgeMain comment=defconf interface=ether19
add bridge=BridgeMain comment=defconf interface=ether20
add bridge=BridgeMain comment=defconf interface=ether21
add bridge=BridgeMain comment=defconf interface=ether22
add bridge=BridgeMain comment=defconf interface=ether23
add bridge=BridgeMain comment=defconf interface=ether24
/ip neighbor discovery-settings
set discover-interface-list=lan
/interface list member
add interface=BridgeMain list=lan
/ip address
add address=192.168.100.1/24 comment=defconf interface=BridgeMain network=\
    192.168.100.0
add address=192.168.0.2/24 interface=ether1 network=192.168.0.0
add address=10.0.10.1/24 interface=VlanMng network=10.0.10.0
add address=10.0.20.1/24 interface=VlanEdu network=10.0.20.0
add address=10.0.30.1/24 interface=VlanCTF network=10.0.30.0
/ip dhcp-client
add interface=ether1 name=client1 use-peer-dns=no use-peer-ntp=no
/ip dhcp-server
add address-pool=*1 interface=BridgeMain lease-time=1w name=server1
add address-pool=PoolMng interface=VlanMng name=DHCPMng
add address-pool=PoolEdu interface=VlanEdu name=DHCPEdu
add address-pool=PoolCTF interface=VlanCTF name=DHCPCTF
/ip dhcp-server network
add address=10.0.10.0/24 dns-server=8.8.8.8 gateway=10.0.10.1
add address=10.0.20.0/24 dns-server=8.8.8.8 gateway=10.0.20.1
add address=10.0.30.0/24 dns-server=8.8.8.8 gateway=10.0.30.1
add address=192.168.100.0/24 dns-server=8.8.8.8 gateway=192.168.100.1
/ip dns
set servers=8.8.8.8,1.1.1.1
/ip firewall address-list
add address=192.168.100.0/24 list=fal
/ip firewall filter
add action=reject chain=input connection-state=new dst-port=8291 protocol=tcp \
    reject-with=tcp-reset src-address-list=!fal
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1 src-address=\
    192.168.100.0/24
add action=src-nat chain=srcnat dst-address=192.168.0.1 out-interface=ether1 \
    src-address=0.0.0.0 to-addresses=192.168.0.2
/ip route
add distance=1 dst-address=0.0.0.0/0 gateway=192.168.0.1
/ip service
set ftp disabled=yes
set telnet disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system clock
set time-zone-name=Europe/Kiev
/system identity
set name="Welthauptstadt Germania"
/tool bandwidth-server
set enabled=no
/tool mac-server
set allowed-interface-list=lan
/tool mac-server mac-winbox
set allowed-interface-list=lan
