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


ipt_del(){
	echo "${FUNCNAME[@]} [TARGET] <NUMBER>"
	sudo iptables -t filter -D $1 $2
	return
}

ipt_del_nat(){
	echo "${FUNCNAME[@]} [TARGET] <NUMBER>"
	sudo iptables -t nat -D $1 $2
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


