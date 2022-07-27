#!/bin/bash

MAC80211_COMMON_DIR=$HOME/mac80211
MAC80211_INSTALL_MOD_PATH=/lib/modules/$(uname -r)

#temoporary implementation for kali
KMAC80211_COMMON_DIR=$HOME/kmac80211


mac80211_show_env(){
	echo "<${FUNCNAME[0]}>"
	echo "mac target 	: $MAC80211_COMMON_DIR"
	echo "install dir 	: $MAC80211_INSTALL_MOD_PATH"

	echo "<DONE>"
	return
}

mac80211_modules_create(){	
	echo "<${FUNCNAME[0]}>"
	cd $MAC80211_COMMON_DIR
	MAC80211_REAL_DIR=$(realpath .)
	#echo "target : $MAC80211_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$MAC80211_REAL_DIR modules
	echo "<DONE>"
	return
}

mac80211_modules_clean(){	
	echo "<${FUNCNAME[0]}>"
	cd $MAC80211_COMMON_DIR
	MAC80211_REAL_DIR=$(realpath .)
	#echo "target : $MAC80211_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$MAC80211_REAL_DIR clean
	echo "<DONE>"
	return
}

mac80211_modules_clean_kali(){	
	echo "<${FUNCNAME[0]}>"
	cd $KMAC80211_COMMON_DIR
	MAC80211_REAL_DIR=$(realpath .)
	#echo "target : $MAC80211_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$MAC80211_REAL_DIR clean
	echo "<DONE>"
	return
}

mac80211_modules_install(){
	echo "<${FUNCNAME[0]}>"
	cd $MAC80211_COMMON_DIR
	MAC80211_REAL_DIR=$(realpath .)

	mac80211_modules_unload

	sudo make \
		-C /lib/modules/$(uname -r)/build \
		M=$MAC80211_REAL_DIR \
		KERNELRELEASE=$(uname -r) \
		modules_install

	sudo depmod -a
	return
}

mac80211_modules_load(){
	echo "<${FUNCNAME[0]}>"

	mac80211_modules_unload
	sudo modprobe mac80211

	return
}

mac80211_modules_unload(){
	echo "<${FUNCNAME[0]}>"

	sudo modprobe -r ath9k_htc
	sudo modprobe -r mac80211

	return
}

mac80211_airo_check_kill(){

	echo "<${FUNCNAME[0]}>"
	#sudo airodump-ng wlan2 -c 7,11 -w wlan2 -o pcap
	return

}

mac80211_airodump(){
	echo "<${FUNCNAME[0]}>"
	sudo airodump-ng wlan0 -c 7,11 -w wlan4 -o pcap
	sudo airodump-ng wlan0 --beacons -w wlan4 -o pcap
	return
}



