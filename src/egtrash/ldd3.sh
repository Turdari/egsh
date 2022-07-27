#!/bin/bash

LDD3_COMMON_DIR=$HOME/ldd3
LDD3_INSTALL_MOD_PATH=/lib/modules/$(uname -r)

ldd3_modules_create(){	
	echo "<${FUNCNAME[0]}>"
	cd $LDD3_COMMON_DIR
	LDD3_REAL_DIR=$(realpath .)
	#echo "target : $LDD3_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$LDD3_REAL_DIR modules
	echo "<DONE>"
	return
}

ldd3_modules_install(){
	echo "<${FUNCNAME[0]}>"
	cd $LDD3_COMMON_DIR
	LDD3_REAL_DIR=$(realpath .)

	sudo make \
		-C /lib/modules/$(uname -r)/build \
		M=$LDD3_REAL_DIR \
		KERNELRELEASE=$(uname -r) \
		modules_install

	sudo depmod -a

	return
}
