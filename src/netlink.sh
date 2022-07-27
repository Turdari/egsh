#!/bin/bash

NETLINK_COMMON_DIR=$HOME/netlink
NETLINK_INSTALL_MOD_PATH=/lib/modules/$(uname -r)

#temoporary implementation for kali


netlink_show_env(){
	echo "<${FUNCNAME[0]}>"
	echo "mac target 	: $NETLINK_COMMON_DIR"
	echo "install dir 	: $NETLINK_INSTALL_MOD_PATH"

	echo "<DONE>"
	return
}

netlink_modules_create(){	
	echo "<${FUNCNAME[0]}>"
	cd $NETLINK_COMMON_DIR
	NETLINK_REAL_DIR=$(realpath .)
	#echo "target : $NETLINK_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$NETLINK_REAL_DIR modules
	echo "<DONE>"
	return
}

netlink_modules_clean(){	
	echo "<${FUNCNAME[0]}>"
	cd $NETLINK_COMMON_DIR
	NETLINK_REAL_DIR=$(realpath .)
	#echo "target : $NETLINK_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$NETLINK_REAL_DIR clean
	echo "<DONE>"
	return
}

netlink_modules_install(){
	echo "<${FUNCNAME[0]}>"
	cd $NETLINK_COMMON_DIR
	NETLINK_REAL_DIR=$(realpath .)

	netlink_modules_unload

	sudo make \
		-C /lib/modules/$(uname -r)/build \
		M=$NETLINK_REAL_DIR \
		KERNELRELEASE=$(uname -r) \
		modules_install

	sudo depmod -a
	return
}

netlink_modules_load(){
	echo "<${FUNCNAME[0]}>"


	return
}

netlink_modules_unload(){
	echo "<${FUNCNAME[0]}>"


	return
}

