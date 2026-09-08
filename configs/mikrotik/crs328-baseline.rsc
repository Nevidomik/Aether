# sep/02/2026 15:12:46 by RouterOS 6.49.20
# software id = 0JUG-TNFT
#
# model = CRS328-24P-4S+
# serial number = A1A10A78FCB6
/interface bridge
add admin-mac=74:4D:28:34:D3:10 auto-mac=no comment=defconf name=bridge_3-24
/interface list
add name=lan
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys \
    supplicant-identity=MikroTik wpa2-pre-shared-key=24RedFloar!
/ip pool
add name=pool1 ranges=192.168.100.50-192.168.100.100
/ip dhcp-server
add address-pool=pool1 disabled=no interface=bridge_3-24 lease-time=1w name=\
    server1
/interface bridge port
add bridge=bridge_3-24 comment=defconf interface=ether3
add bridge=bridge_3-24 comment=defconf interface=ether4
add bridge=bridge_3-24 comment=defconf interface=ether5
add bridge=bridge_3-24 comment=defconf interface=ether6
add bridge=bridge_3-24 comment=defconf interface=ether7
add bridge=bridge_3-24 comment=defconf interface=ether8
add bridge=bridge_3-24 comment=defconf interface=ether9
add bridge=bridge_3-24 comment=defconf interface=ether10
add bridge=bridge_3-24 comment=defconf interface=ether11
add bridge=bridge_3-24 comment=defconf interface=ether12
add bridge=bridge_3-24 comment=defconf interface=ether13
add bridge=bridge_3-24 comment=defconf interface=ether14
add bridge=bridge_3-24 comment=defconf interface=ether15
add bridge=bridge_3-24 comment=defconf interface=ether16
add bridge=bridge_3-24 comment=defconf interface=ether17
add bridge=bridge_3-24 comment=defconf interface=ether18
add bridge=bridge_3-24 comment=defconf interface=ether19
add bridge=bridge_3-24 comment=defconf interface=ether20
add bridge=bridge_3-24 comment=defconf interface=ether21
add bridge=bridge_3-24 comment=defconf interface=ether22
add bridge=bridge_3-24 comment=defconf interface=ether23
add bridge=bridge_3-24 comment=defconf interface=ether24
/ip neighbor discovery-settings
set discover-interface-list=lan
/interface list member
add interface=bridge_3-24 list=lan
/ip address
add address=192.168.100.1/24 comment=defconf interface=bridge_3-24 network=\
    192.168.100.0
add address=192.168.0.2/24 interface=ether1 network=192.168.0.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
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
/ip service
set telnet disabled=yes
set ftp disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system clock
set time-zone-name=Europe/Kiev
/system identity
set name=CapitalOfWorld
/system routerboard settings
set boot-os=router-os
/tool bandwidth-server
set enabled=no
/tool mac-server
set allowed-interface-list=lan
/tool mac-server mac-winbox
set allowed-interface-list=lan
