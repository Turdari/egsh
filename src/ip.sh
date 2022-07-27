#!/bin/bash



IFNAME=enp3s0
#IFNAME=enx2887baf40759


ip_ping_arp_setup()
{
    ping -c 2 -I $IFNAME.1 10.0.10.2
    ping -c 2 -I $IFNAME.2 10.0.10.2
    ping -c 2 10.0.10.6
}

#ip_route_set()
#{
#	echo "<ip route set>"
#	sudo ip route add 192.168.1.0/24 via 192.168.12.254 dev eth0 
#	sudo ip route del default via 192.168.12.254 dev eth0 src 192.168.12.153 metric 202	
#
#	return
#}

ip_link_add()
{
	echo "sudo ip link add link $IFNAME address 00:11:11:11:11:11 $IFNAME.1 type macvlan"
	sudo ip link add link $IFNAME address 00:11:11:11:11:11 $IFNAME.1 type macvlan
	sudo ip link add link $IFNAME address 00:22:22:22:22:22 $IFNAME.2 type macvlan

	sudo ip link set $IFNAME.1 up
	sudo ip link set $IFNAME.2 up
	return
}

ip_link_del()
{
	echo "sudo ip link del"

	sudo ip link set $IFNAME.1 down
	sudo ip link set $IFNAME.2 down

	sudo ip link del link $IFNAME address 00:11:11:11:11:11 $IFNAME.1 type macvlan
	sudo ip link del link $IFNAME address 00:22:22:22:22:22 $IFNAME.2 type macvlan

	return
}

ip_address_add()
{
	sudo ip address add dev $IFNAME 10.0.10.1/24
	sudo ip address add dev $IFNAME.1 10.0.10.3/24
	sudo ip address add dev $IFNAME.2 10.0.10.5/24
	return
}

ip_address_add()
{
	sudo ip address del dev $IFNAME 10.0.10.1/24
	sudo ip address del dev $IFNAME.1 10.0.10.3/24
	sudo ip address del dev $IFNAME.2 10.0.10.5/24
	return
}

ip_route_simple()
{
    sudo ip r del 10.0.10.0/24 dev $IFNAME
    sudo ip r del 10.0.10.0/24 dev $IFNAME.1
    sudo ip r del 10.0.10.0/24 dev $IFNAME.2


    sudo ip r add 10.0.10.2 dev $IFNAME                                                                                                                                      
    sudo ip r add 10.0.10.6 dev $IFNAME.1                                                                                                                                       
    sudo ip r add 10.0.10.4 dev $IFNAME.2
    return
}


ip_arp_set()
{
    sudo arp -i $IFNAME.1 -s 10.0.10.6 00:11:22:33:44:55                                                                                                                        
    sudo arp -i $IFNAME.2 -s 10.0.10.4 00:11:22:33:44:55 
    return
}

ip_pc1_set()
{
	echo "ip link, address, route set for pc1"

    URIPADDR="10.0.10.11"
    MYIPADDR="10.0.10.10"
    MYMACADDR="96:63:37:58:11:11"
	
    sudo ip link set $IFNAME down
	sudo ip link set $IFNAME.1 down

	sudo ip link add link $IFNAME address $MYMACADDR $IFNAME.1 type macvlan

	sudo ip address del dev $IFNAME 10.0.10.1/24
	sudo ip address del dev $IFNAME.1 $URIPADDR/24
	sudo ip address del dev $IFNAME.1 $MYIPADDR/24
	
	sudo ip address add dev $IFNAME 10.0.10.1/24
	sudo ip address add dev $IFNAME.1 $MYIPADDR/24

	sudo ip link set $IFNAME up
	sudo ip link set $IFNAME.1 up

    sudo ip r del 10.0.10.2 dev $IFNAME
    sudo ip r del 10.0.10.0/24 dev $IFNAME
    sudo ip r del 10.0.10.0/24 dev $IFNAME.1

    sudo ip r add 10.0.10.2 dev $IFNAME  
    sudo ip r add 10.0.10.0/24 dev $IFNAME.1                                                                                                                               
    
    return
}

ip_pc2_set()
{
	echo "ip link, address, route set for pc2"
  
    URIPADDR="10.0.10.10"
    MYIPADDR="10.0.10.11"
    MYMACADDR="96:63:37:58:22:11"
	
    sudo ip link set $IFNAME down
	sudo ip link set $IFNAME.1 down

	sudo ip link add link $IFNAME address $MYMACADDR $IFNAME.1 type macvlan

	sudo ip address del dev $IFNAME 10.0.10.1/24
	sudo ip address del dev $IFNAME.1 $URIPADDR/24
	sudo ip address del dev $IFNAME.1 $MYIPADDR/24
	
	sudo ip address add dev $IFNAME 10.0.10.1/24
	sudo ip address add dev $IFNAME.1 $MYIPADDR/24

	sudo ip link set $IFNAME up
	sudo ip link set $IFNAME.1 up

    sudo ip r del 10.0.10.2 dev $IFNAME
    sudo ip r del 10.0.10.0/24 dev $IFNAME
    sudo ip r del 10.0.10.0/24 dev $IFNAME.1

    sudo ip r add 10.0.10.2 dev $IFNAME  
    sudo ip r add 10.0.10.0/24 dev $IFNAME.1                                                                                                                               
 
    return
}
