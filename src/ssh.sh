#!/bin/bash


#set server ssh tunnel in client 
ssh_tunnel_client_set_vnc()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 >"

#	The -L switch specifies the port bindings. 
#	In this case we’re binding port 5901 of the remote connection to port 5901 on your local machine. 
#	The -C switch enables compression, 
#	while the -N switch tells ssh that we don’t want to execute a remote command. 
#	The -l switch specifies the remote login name.

	[ ! -z $1 ] && [ ! -z $2 ] && ssh -L 5902:127.0.0.1:5902 -C -N -l $1 $2
	#ssh -L 127.0.0.1:5901:127.0.0.1:5901 -C -N -l $1 $2
	return
}

#ssh_tunnel_client_unset_vnc()
#{
#	
#	return
#}



