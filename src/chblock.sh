#!/bin/bash

#prerequisite : ipset
cnzone_create()
{
	echo "${FUNCCNAME[0]}"
	# Create the ipset list
	sudo ipset -N china hash:net
	
	# remove any old list that might exist from previous runs of this script
	rm -f cn.zone
	
	# Pull the latest IP set for China
	wget -P . http://www.ipdeny.com/ipblocks/data/countries/cn.zone
	
	# Add each IP address from the downloaded list into the ipset 'china'
	for i in $(cat cn.zone ); 
	do sudo ipset -A china $i; 
	done

	return
}

cnzone_apply()
{
	echo "${FUNCCNAME[0]}"
	sudo iptables -A INPUT -p tcp -m set --match-set china src -j DROP
	return
}
## Restore iptables
#/sbin/iptables-restore < /etc/iptables.firewall.rules


