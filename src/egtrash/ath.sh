#!/bin/bash

ATH_COMMON_DIR=$HOME/ath9k
ATH_INSTALL_MOD_PATH=/lib/modules/$(uname -r)

#temporal implementation
KATH_COMMON_DIR=$HOME/kath9k


ath_show_env(){
	echo "<${FUNCNAME[0]}>"
	echo "ath target 	: $ATH_COMMON_DIR"
	echo "install dir 	: $ATH_INSTALL_MOD_PATH"

	echo "<DONE>"
	return
}

ath_modules_create(){	
	echo "<${FUNCNAME[0]}>"
	cd $ATH_COMMON_DIR
	ATH_REAL_DIR=$(realpath .)
	#echo "target : $ATH_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$ATH_REAL_DIR modules
	echo "<DONE>"
	return
}

ath_modules_clean(){	
	echo "<${FUNCNAME[0]}>"
	cd $ATH_COMMON_DIR
	ATH_REAL_DIR=$(realpath .)
	#echo "target : $ATH_REAL_DIR"

	sudo make -C /lib/modules/$(uname -r)/build M=$ATH_REAL_DIR clean
	echo "<DONE>"
	return
}

ath_modules_clean_kali(){	
	echo "<${FUNCNAME[0]}>"
	cd $KATH_COMMON_DIR
	ATH_REAL_DIR=$(realpath .)
	#echo "target : $ATH_REAL_DIR"

	sudo make -C /lib/modules/$(uname -r)/build M=$ATH_REAL_DIR clean
	echo "<DONE>"
	return
}


ath_modules_install(){
	echo "<${FUNCNAME[0]}>"
	cd $ATH_COMMON_DIR
	ATH_REAL_DIR=$(realpath .)

	ath_modules_unload

	sudo make \
		-C /lib/modules/$(uname -r)/build \
		M=$ATH_REAL_DIR \
		KERNELRELEASE=$(uname -r) \
		modules_install

	sudo depmod -a
	return
}

ath_modules_load(){
	echo "<${FUNCNAME[0]}>"

	sudo modprobe -r ath9k_htc
	sudo modprobe ath9k_htc

	return
}

ath_modules_unload(){
	echo "<${FUNCNAME[0]}>"

	sudo modprobe -r ath9k_htc

	return
}

ath_airo_check_kill(){

	echo "<${FUNCNAME[0]}>"
	#sudo airodump-ng wlan2 -c 7,11 -w wlan2 -o pcap
	return

}

ath_airodump(){
	echo "<${FUNCNAME[0]}>"
#	sudo airodump-ng wlan4 -c 7,11 -w wlan4 -o pcap
	sudo airodump-ng wlan4 --beacons -w wlan4 -o pcap
	return
}



