#!/bin/bash

CFG80211_COMMON_DIR=$HOME/wireless
CFG80211_INSTALL_MOD_PATH=/lib/modules/$(uname -r)


cfg80211_show_env(){
	echo "<${FUNCNAME[0]}>"
	echo "cfg target 	: $CFG80211_COMMON_DIR"
	echo "install dir 	: $CFG80211_INSTALL_MOD_PATH"

	echo "<DONE>"
	return
}

cfg80211_mcreate_tmp(){
	echo "<${FUNCNAME[0]}>"
	echo "sudo make M=$PWD/net/wireless modules"
	sudo make M=$PWD/net/wireless modules
	return
}

cfg80211_minstall_tmp(){
	echo "<${FUNCNAME[0]}>"
	echo "sudo make M=$PWD/net/wireless modules"
	sudo make M=$PWD/net/wireless KERNELRELEASE=$(uname -r) modules_install
	sudo depmod -a
	return
}

cfg80211_modules_create(){	
	echo "<${FUNCNAME[0]}>"
	cd $CFG80211_COMMON_DIR
	CFG80211_REAL_DIR=$(realpath .)
	#echo "target : $CFG80211_REAL_DIR"

	echo "sudo make V=2 -C /lib/modules/$(uname -r)/build M=$CFG80211_REAL_DIR modules"

	sudo make V=2 -C /lib/modules/$(uname -r)/build M=$CFG80211_REAL_DIR modules
	echo "<DONE>"
	return
}

cfg80211_modules_clean(){	
	echo "<${FUNCNAME[0]}>"
	cd $CFG80211_COMMON_DIR
	CFG80211_REAL_DIR=$(realpath .)
	#echo "target : $CFG80211_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$CFG80211_REAL_DIR clean
	echo "<DONE>"
	return
}

cfg80211_modules_install(){
	echo "<${FUNCNAME[0]}>"
	cd $CFG80211_COMMON_DIR
	CFG80211_REAL_DIR=$(realpath .)

	cfg80211_modules_unload

	sudo make \
		-C /lib/modules/$(uname -r)/build \
		M=$CFG80211_REAL_DIR \
		KERNELRELEASE=$(uname -r) \
		modules_install

	sudo depmod -a
	return
}

cfg80211_modules_load(){
	echo "<${FUNCNAME[0]}>"

	cfg80211_modules_unload
	sudo modprobe cfg80211

	return
}

cfg80211_modules_unload(){
	echo "<${FUNCNAME[0]}>"

	sudo modprobe -r cfg80211

	return
}

