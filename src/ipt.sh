ipt_show(){
	echo ${FUNCNAME[@]}
	sudo iptables -S -v
	sudo iptables -L -v
	return
}

ipt_show_nat(){
	echo ${FUNCNAME[@]}
	sudo iptables -t nat -S -v
	sudo iptables -t nat -L -v
	return
}


ipt_del_all(){
	echo "${FUNCNAME[@]} "
	sudo iptables -F
	sudo iptables -t nat -F
	return
}

ipt_forward_home_net()
{
	echo "${FUNCNAME[@]}"

	#echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
	#enx705dccf1a08b
	sudo iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
	sudo iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE
	sudo iptables -I FORWARD -i enx705dccf1a08b -j ACCEPT
	sudo iptables -I FORWARD -o enx705dccf1a08b -m state --state RELATED,ESTABLISHED -j ACCEPT

#iptables-save  > /etc/iptables/rules.v4
#ip6tables-save > /etc/iptables/rules.v6

	return
}


ipt_test_interface_port_forward()
{
	echo "${FUNCNAME[@]}"
    HOST_IFNAME_A=ppp0
    HOST_IFNAME_B=ens3
    HOST_PORT=2204
    TARGET_ADDR=192.168.200.4
    #TARGET_PORT=2204
    HOST_PORT_SSH1=2201
    #HOST_PORT_SSH2=2202
    HOST_PORT_SSH3=2203
    HOST_PORT_SSH4=2204
    TARGET_ADDR_PC1=192.168.200.1
    #TARGET_ADDR_PC2=192.168.200.2
    TARGET_ADDR_PC3=192.168.200.3
    TARGET_ADDR_PC4=192.168.200.4

    # make DNAT for specific packet
    #sudo iptables -t nat -A PREROUTING -i $HOST_IFNAME_A -p tcp --dport $HOST_PORT -j DNAT --to-destination $TARGET_ADDR:$TARGET_PORT
    #sudo iptables -t nat -A PREROUTING -i $HOST_IFNAME_A -p tcp --dport $HOST_PORT -j DNAT --to-destination $TARGET_ADDR
    sudo iptables -t nat -A PREROUTING -i $HOST_IFNAME_A -p tcp --dport $HOST_PORT_SSH1 -j DNAT --to-destination $TARGET_ADDR_PC1
    sudo iptables -t nat -A PREROUTING -i $HOST_IFNAME_A -p tcp --dport $HOST_PORT_SSH3 -j DNAT --to-destination $TARGET_ADDR_PC3
    sudo iptables -t nat -A PREROUTING -i $HOST_IFNAME_A -p tcp --dport $HOST_PORT_SSH4 -j DNAT --to-destination $TARGET_ADDR_PC4
    # forward packet between two interfaces (only valid one)
    #sudo iptables -A FORWARD -i $HOST_IFNAME_A -o $HOST_IFNAME_B -p tcp --dport $TARGET_PORT -d $TARGET_ADDR -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i $HOST_IFNAME_A -o $HOST_IFNAME_B -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
    sudo iptables -A FORWARD -i $HOST_IFNAME_B -o $HOST_IFNAME_A -m state --state ESTABLISHED -j ACCEPT
    #sudo iptables -A FORWARD -i $HOST_IFNAME_B -o $HOST_IFNAME_A -j ACCEPT
    # below rule responsible for creating packet going out from -o interface (and also handles returning packet)
    sudo iptables -t nat -A POSTROUTING -o $HOST_IFNAME_A -j MASQUERADE
    sudo iptables -t nat -A POSTROUTING -o $HOST_IFNAME_B -j MASQUERADE

    # example from chatgpt
#    iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2222 -j DNAT --to-destination 192.168.200.2:22
#    iptables -A FORWARD -i eth0 -o eth1 -p tcp --dport 22 -d 192.168.200.2 -m state --state NEW,ESTABLISHED -j ACCEPT
#    iptables -A FORWARD -i eth1 -o eth0 -m state --state ESTABLISHED -j ACCEPT
#    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    # second example from chatgpt 
    #iptables -t nat -A POSTROUTING -s $TARGET_ADDR_RANGE -d 115.144.233.222/32 -p tcp --dport 2200:2299 -j SNAT -to-source 115.144.233.222

    return 
}



