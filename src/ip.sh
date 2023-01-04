#!/bin/bash

#TEST_ISLOOP=TRUE or FALSE
TEST_ISLOOP=TRUE
TEST_PCNUMBER=0
IFNAME=enp3s0

LOOP_MACADDR_03="00:03:03:03:03:03"
LOOP_MACADDR_05="00:05:05:05:05:05"
MYMACADDR="00:10:10:10:10:10"
URMACADDR="00:11:11:11:11:11"

ip_pc1_arp_set()
{
    return
}
ip_pc2_arp_set()
{
    sudo arp -i $IFNAME.1 -s 10.0.10.10 00:11:22:33:44:55
    return
}
ip_pc1_set()
{
	echo "ip link, address, route set for pc1"

    URIPADDR="10.0.10.11"
    MYIPADDR="10.0.10.10"
    MYMACADDR="96:63:37:58:11:11"
	
    sudo ip link set $IFNAME down
	sudo ip address del dev $IFNAME $MYIPADDR/24
	sudo ip address add dev $IFNAME $MYIPADDR/24
	sudo ip link set $IFNAME up
    sudo arp -i $IFNAME -d $URIPADDR 00:11:22:33:44:55
    sudo arp -i $IFNAME -s $URIPADDR 00:11:22:33:44:55
    sudo ip r del 10.0.10.0/24 dev $IFNAME
    sudo ip r add 10.0.10.0/24 dev $IFNAME
    
    return
}
ip_pc2_set()
{
	echo "ip link, address, route set for pc2"

    URIPADDR="10.0.10.10"
    MYIPADDR="10.0.10.11"
    MYMACADDR="96:63:37:58:22:11"
	
    sudo ip link set $IFNAME down
	sudo ip address del dev $IFNAME $MYIPADDR/24
	sudo ip address add dev $IFNAME $MYIPADDR/24
	sudo ip link set $IFNAME up
    sudo arp -i $IFNAME -d $URIPADDR 00:11:22:33:44:55
    sudo arp -i $IFNAME -s $URIPADDR 00:11:22:33:44:55
    sudo ip r del 10.0.10.0/24 dev $IFNAME
    sudo ip r add 10.0.10.0/24 dev $IFNAME
  
 
    return
}
ip_pc1_set2()
{
	echo "ip link, address set for pc1"
    MYIPADDR="10.0.10.10"
    MYMACADDR="96:63:37:58:11:11"

    sudo ip link set $IFNAME down
	sudo ip address del dev $IFNAME.1 $MYIPADDR/24
	sudo ip link del link $IFNAME address $MYMACADDR $IFNAME.1 type macvlan
	sudo ip link add link $IFNAME address $MYMACADDR $IFNAME.1 type macvlan
	sudo ip address add dev $IFNAME.1 $MYIPADDR/24
	sudo ip link set $IFNAME up
	sudo ip link set $IFNAME.1 up

    sudo ip r add 10.0.10.0/24 dev $IFNAME.1
}
ip_pc2_set2()
{
	echo "ip link, address set for pc2"
    MYIPADDR="10.0.10.11"
    MYMACADDR="96:63:37:58:22:11"

    sudo ip link set $IFNAME down
	sudo ip address del dev $IFNAME.1 $MYIPADDR/24
	sudo ip link del link $IFNAME address $MYMACADDR $IFNAME.1 type macvlan
	sudo ip link add link $IFNAME address $MYMACADDR $IFNAME.1 type macvlan
	sudo ip address add dev $IFNAME.1 $MYIPADDR/24
	sudo ip r add address add dev $IFNAME.1 $MYIPADDR/24
	sudo ip link set $IFNAME up
	sudo ip link set $IFNAME.1 up

    sudo ip r add 10.0.10.0/24 dev $IFNAME.1

}

### Table for test environment
##  loop mode 
#   IP                  MAC                 Comment
#   10.0.10.1           
#   10.0.10.3           00:03:03:03:03:03   LOOP 10.0.10.4 in 10.0.10.5 view
#   10.0.10.5           00:05:05:05:05:05   LOOP 10.0.10.6 in 10.0.10.3 view
#   10.0.10.10          00:10:10:10:10:10   TEST_PCNUMBER 0 acquire this interface
#   10.0.10.11          00:11:11:11:11:11   TEST_PCNUMBER 1 acquire this interface
ip_testenv_set_loop_enabled()
{
    echo "loop enabled"
    
    sudo ip link set $IFNAME down
    sudo ip link add link $IFNAME address $LOOP_MACADDR_03 $IFNAME.1 type macvlan
    sudo ip link add link $IFNAME address $LOOP_MACADDR_05 $IFNAME.2 type macvlan
    sudo ip address add dev $IFNAME.1 10.0.10.3/24
    sudo ip address add dev $IFNAME.2 10.0.10.5/24
    sudo ip link set $IFNAME.1 up
    sudo ip link set $IFNAME.2 up
    sudo ip link set $IFNAME up

    #delete default route and add direct route
    sudo ip r del 10.0.10.0/24 dev $IFNAME
    sudo ip r del 10.0.10.0/24 dev $IFNAME.1
    sudo ip r del 10.0.10.0/24 dev $IFNAME.2
    sudo ip r add 10.0.10.2 dev $IFNAME                                                                                                                                      
    sudo ip r add 10.0.10.6 dev $IFNAME.1                                                                                                                                       
    sudo ip r add 10.0.10.4 dev $IFNAME.2

    # ~ should be set into
    # select interface where specific address should select,
    # address should
    sudo arp -i $IFNAME.1 -s 10.0.10.6 00:11:22:33:44:55
    sudo arp -i $IFNAME.2 -s 10.0.10.4 00:11:22:33:44:55
}
ip_testenv_set_loop_disabled()
{
    echo "loop disabled, check pc number"

}
ip_testenv_clear()
{
    sudo ip link set $IFNAME down
	sudo ip link del link $IFNAME address $LOOP_MACADDR_03 $IFNAME.1 type macvlan
	sudo ip link del link $IFNAME address $LOOP_MACADDR_05 $IFNAME.2 type macvlan
	sudo ip link del link $IFNAME address $URMACADDR $IFNAME.3 type macvlan
	sudo ip link del link $IFNAME address $MYMACADDR $IFNAME.4 type macvlan
	sudo ip link set $IFNAME up
}
ip_testenv_set()
{
    ip_testenv_clear

    if [ $TEST_ISLOOP == 'TRUE' ]
    then ip_testenv_set_loop_enabled
    elif [ $TEST_ISLOOP == 'FALSE' ]
    then ip_testenv_set_loop_disabled
    else
        echo "SET TEST_ISLOOP variable in script!"
    fi
}


