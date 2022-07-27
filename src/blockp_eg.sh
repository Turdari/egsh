#!/bin/bash

# this script must run with Makefile for PWD syncing 

blockp_create_empty(){
	echo "${FUNCNAME[0]} <string:filename>"
	echo "example :"
	printf "\t${FUNCNAME[0]} example.img\n"

	# method
	#dd if=/dev/zero of=upload_test bs=file_size count=1
	#dd if=/dev/zero of=upload_test bs=1M count=size_in_megabytes
	#dd of=$1 seek=7800M bs=1 count=0
#	# nice command for moving into root shell with env preserved 
#	sudo -Es 
	if [ ! -z $1 ] ; then 
		# bs.... and count.. ? 	
		# seek to 3900M and write nothing... it is fastest.. 
		# but does it ensures 0 filled?
		dd of=$1 seek=7000M bs=1 count=0
		#dd if=/dev/zero of=$1 bs=1M count=7800
	fi


	return 
}

blockp_create_partition(){
	echo "${FUNCNAME[0]} <string:filename>"
	echo "example :"
	printf "\t${FUNCNAME[0]} example.img\n"
	
	if [ ! -z $1 ] ; then 
		sudo parted $1 mktable msdos
		# sudo parted $1 mkpart primary fat32 2048s 257MiB
		# align to real sector size 8192
		sudo parted $1 mkpart primary fat32 8192s 260MiB
		sudo parted $1 mkpart primary ext4 260MiB 100%
	fi

	return
}

blockp_format_partition() {
	echo "${FUNCNAME[0]} <loopdev:/dev/loopX>"
	echo "example :"
	printf "\t${FUNCNAME[0]} /dev/loop0\n"

	if [ ! -z $1 ] ; then 
		sudo mkfs.vfat -F 32 -n boot $1p1
		sudo mkfs.ext4 -L rootfs $1p2
	fi

	return
}


