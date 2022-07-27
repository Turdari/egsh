#!/bin/bash

block_dd_create_img(){
        echo "${FUNCNAME[0]} <device name> <filename>"

        [ -z $1 ] && exit -1
        sudo dd bs=4M if=$1 > $2
        return
}

block_dd_write_img(){
        echo "${FUNCNAME[0]} <device name> <filename>"

        [ -z $1 ] && exit -1
        sudo dd bs=4M if=$2 of=$1
        return
}

block_dd_gzimage_create(){
	echo "${FUNCNAME[0]} <device name> <filename>"

	[ -z $1 ] && exit -1
	sudo dd bs=4M if=$1 | gzip > $2
	#sudo dd bs=4M if=/dev/sda | gzip > temp.img.gz
	return
}

block_dd_gzimage_write(){
	echo "${FUNCNAME[0]} <device name> <filename>"

	[ -z $1 ] && exit -1
	gunzip --stdout $2 | sudo dd bs=4M of=$1
	return
}

block_resize2fs()
{
	echo "${FUNCNAME[0]} <device name>"

	[ -z $1 ] && exit -1
	sudo resize2fs $1
	return
}


