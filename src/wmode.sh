#!/bin/bash

EGSHARE=/etc/netgene
CONFDIR=/etc/netgene/wmode

wmode_show(){
	echo "$0"
	echo "<default>"
	sudo systemctl is-enabled wifi-demo-default.service
	echo "<sta>"
	sudo systemctl is-enabled wifi-demo-sta.service
	echo "<ap>"
	sudo systemctl is-enabled wifi-demo-ap.service
	return;
}

wmode_set(){
	echo "${FUNCNAME[0]}"


	if [ -z $1 ]
	then	echo "Usage : ${FUNCNAME[0]} < default | sta | ap | disable >"
	else 	echo "$1"

case $1 in
	sta )
		if cat /proc/device-tree/model | grep -q "Pi 4" ; 
		then	sudo cp $CONFDIR/config.txt.4b /boot/config.txt && echo "machine : Pi4" 
		else	sudo cp $CONFDIR/config.txt.3bp /boot/config.txt && echo "machine : Pi3B" 
		fi
		sudo systemctl disable wifi-demo-default.service
		sudo systemctl disable wifi-demo-sta.service
		sudo systemctl disable wifi-demo-ap.service

		CDIR=$CONFDIR/sta #conf

		if [ -d $CDIR ] && [ -f $CDIR/dhcpcd.conf ] 
		then	sudo cp $CDIR/dhcpcd.conf /etc/dhcpcd.conf
			sudo systemctl enable wifi-demo-$1.service
			echo "Done"
		else	echo ""
			echo "Error : Prerequisite fail"
		fi

		sudo systemctl daemon-reload 
	;;
	ap )
		if cat /proc/device-tree/model | grep -q "Pi 4" ; 
		then	sudo cp $CONFDIR/config.txt.4b /boot/config.txt && echo "machine : Pi4" 
		else	sudo cp $CONFDIR/config.txt.3bp /boot/config.txt && echo "machine : Pi3B" 
		fi
		sudo systemctl disable wifi-demo-default.service
		sudo systemctl disable wifi-demo-sta.service
		sudo systemctl disable wifi-demo-ap.service
		
		CDIR=$CONFDIR/ap #conf
		
		if [ -d $CDIR ] && [ -f $CDIR/dhcpcd.conf ] #does directory exist?
		then 	sudo cp $CDIR/dhcpcd.conf /etc/dhcpcd.conf
			sudo systemctl enable wifi-demo-$1.service
			echo "Done"
		else 	echo ""
			echo "Error : Prerequisite fail"
		fi
	
		sudo systemctl daemon-reload #not needed.. all path closed 
	;;
	default )
		if cat /proc/device-tree/model | grep -q "Pi 4" ; 
		then	sudo cp $CONFDIR/config.txt.4b /boot/config.txt && echo "machine : Pi4" 
		else	sudo cp $CONFDIR/config.txt.3bp /boot/config.txt && echo "machine : Pi3B" 
		fi
		sudo systemctl disable wifi-demo-default.service
		sudo systemctl disable wifi-demo-sta.service
		sudo systemctl disable wifi-demo-ap.service

		if [ -d $CONFDIR/default ] 
		then	sudo systemctl enable wifi-demo-$1.service
			echo "Done"
		else 	echo ""
			echo "Error : Prerequisite fail, run <wmode_set disable>"
		fi

		sudo systemctl daemon-reload
	;;
	disable )
		if cat /proc/device-tree/model | grep -q "Pi 4" ; 
		then	sudo cp $CONFDIR/config.txt.4b /boot/config.txt && echo "machine : Pi4" 
		else	sudo cp $CONFDIR/config.txt.3bp /boot/config.txt && echo "machine : Pi3B" 
		fi
		sudo systemctl disable wifi-demo-default.service
		sudo systemctl disable wifi-demo-sta.service
		sudo systemctl disable wifi-demo-ap.service

		#check is pi4 and set config.txt
		#set ip 192.168.12.153 (comp's local ip)
		[ -f /etc/dhcpcd.conf.org ] && sudo cp /etc/dhcpcd.conf.org /etc/dhcpcd.conf
		sudo systemctl daemon-reload
		echo "Done"
	;;
	* )
		echo "Parameter Invalid (Command not exist)"
	;;
esac

	fi

	return;
}

wmode_wifi_status()
{
	echo "$0 < default | sta | ap >"
	[ -z $1 ] || sudo systemctl status wifi-demo-$1.service

	return 
}



wmode_wifi_ld()
{
	echo "$0 < default | sta | ap >"
	[ -z $1 ] || sudo systemctl list-dependencies wifi-demo-$1.service
	
	return 
}

wmode_ipt_ap()
{
	echo "<iptables set AP>"
	sudo iptables -I FORWARD -i wlan0 -j ACCEPT
	sudo iptables -I FORWARD -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

	return
}

wmode_ipt_sta()
{
	echo "<iptables set STA>"
	sudo iptables -I FORWARD -i usb0 -j ACCEPT
	sudo iptables -I FORWARD -o usb0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
	return
}

wmode_temp_wlan0_mon()
{
	echo "${FUNCNAME[0]}"

	sudo ifconfig wlan0 down
	sudo iw dev wlan0 set monitor control
	sudo ifconfig wlan0 up

	return
}

wmode_temp_wlan0_man()
{
	echo "${FUNCNAME[0]}"

	sudo ip link set dev wlan0 down
	sudo iwconfig wlan0 mode managed
	sudo ip link set dev wlan0 up

	return
}

