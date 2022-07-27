#!/bin/bash

temp()
{
	echo "temp"

	return
}

img2qcow()
{
	echo "img2qcow <name.img> <name.qcow2>"
	#raw img to qcow2
	qemu-img convert -f raw -O qcow2 $1 $2 
	return
}

setup_net()
{
	sudo virsh net-start default
	sudo tunctl -t tap0
	sudo ifconfig tap0 up
	sudo brctl addif virbr0 tap0
	sudo brctl show
	return
}

setup_net2()
{
#	sudo brctl addbr virbr0
	sudo tunctl -t tap0
	sudo ifconfig tap0 192.168.100.1 up
	#sudo brctl addif virbr0 tap0
	#sudo brctl show

#echo 1 > /proc/sys/net/ipv4/ip_forward
#iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
#iptables -I FORWARD 1 -i tap0 -j ACCEPT
#iptables -I FORWARD 1 -o tap0 -m state --state RELATED,ESTABLISHED -j ACCEPT

	return
}

ipt_forward()
{
	echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
	sudo iptables -t nat -A PREROUTING -d 10.178.1.0 -j DNAT --to-destination 192.168.122.171
	sudo iptables -t nat -A POSTROUTING -s 192.168.122.171 -j MASQUERADE
	sudo iptables -A INPUT -p udp -j ACCEPT
	sudo iptables -A FORWARD -p tcp -j ACCEPT
	sudo iptables -A OUTPUT -p tcp -j ACCEPT
	sudo iptables -A OUTPUT -p udp -j ACCEPT
	return
}

ipt_forward2()
{
	echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
	sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
	sudo iptables -I FORWARD -i wlan0 -j ACCEPT
	sudo iptables -I FORWARD -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	return
}





tmux_0()
{
	echo "tmux_0 <img.qcow2>"
	#sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 -net nic -net tap,ifname=tap0,script=no -curses 
	#for old linux setup old network model model=e1000 model=rtl8139
	sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 -net nic,model=rtl8139 -net tap,ifname=tap0,script=no -curses 
	return
}

tmux_1()
{
	echo "tmux_1 <img.qcow2>"
	#sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 -net nic -net tap,ifname=tap0,script=no -curses 
	#for old linux setup old network model model=e1000 model=rtl8139
	sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 \
		-netdev tap,ifname=tap0,id=n1,script=no \
		-device e1000,netdev=n1,mac=52:54:98:76:54:32 \
		-curses 
	return
}

tmux_2()
{
	echo "tmux_2 <img.qcow2>"
	#sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 -net nic -net tap,ifname=tap0,script=no -curses 
	#for old linux setup old network model model=e1000 model=rtl8139
	sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 \
		-netdev tap,ifname=tap0,id=n1,script=no \
		-device rtl8139,netdev=n1,mac=52:54:98:76:54:32 \
		-curses 
	return
}

tmux_3()
{
	echo "tmux_3 <img.qcow2>"

	#try samba...

	#sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 -net nic -net tap,ifname=tap0,script=no -curses 
	#for old linux setup old network model model=e1000 model=rtl8139
	sudo qemu-system-i386 -enable-kvm -hda $1 -m 512 \
		-netdev tap,ifname=tap0,id=n1,script=no \
		-device rtl8139,netdev=n1,mac=52:54:98:76:54:32 \
		-net user,smb=/usr/share/samba \
		-net nic,model=virtio \
		-curses
	return
}

tdump_sall()
{
	echo "tcpdump_start_all"

	sudo tcpdump -i tap0 -w ~/tap.pcap &
	echo $! >> /tmp/tcpdump_pid
	#sudo tcpdump -i virbr0 -w ~/virbr.pcap & 
	sudo tcpdump -i enp1s0f0 -w ~/eth.pcap & 
	echo $! >> /tmp/tcpdump_pid

	return
}

tdump_kall()
{	
	echo "tcpdump_kill_all"
	sudo kill $(cat /tmp/tcpdump_pid)
	printf "" > /tmp/tcpdump_pid

	return
}

