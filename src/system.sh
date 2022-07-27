#!/bin/bash


egsystem_dir_setgroup()
{
	echo "${FUNCNAME[0]} <directory> <groupname> "
	#set group permissions same as user permissions
	if [ -d $1 ] && [ ! -z $2 ] 
	then 	echo "Parameter Valid"
		sudo chown -R :$2 $1
	else 	echo "Parameter Invalid"
	fi

	return
}


egsystem_dir_syncpermission()
{
	echo "${FUNCNAME[0]} <directory>"
	#Make group permissions same as user permissions
	[ ! -z $1 ] && sudo chmod -R g=u $1 || echo "Parameter Invalid"

	return
}

egsystem_add_group2usr()
{	
	echo "${FUNCNAME[0]} <groupname> <username>"
	[ -z $1 ] && return
	[ -z $2 ] && return
	#sudo groupadd $1
	sudo usermod -a -G $1 $2

	return
}

egsystem_ls_group()
{	
	echo "${FUNCNAME[0]}"
	echo $(cat /etc/group | sed -r 's/(^\w+).*/\1/' )
	#same result
	#echo $(cat /etc/group | sed -nr 's/(^\w+).*/\1/p' )

	return
}


