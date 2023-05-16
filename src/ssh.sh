#!/bin/bash


ssh_tunnel()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 > <port_range>"

    return
}

ssh_reverse_tunnel()
{
    if [ "$#" -ne 3 ]; then
        echo "Usage: ${FUNCNAME[0]} <user> <server_ipv4> <port>"
        return 1
    fi

    local user="$1"
    local server="$2"
    local port="$3"

    # Create the reverse tunnel
    ssh -nNT -R $port:localhost:$port $user@$server
}

sshx_app()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 > <port> <app-name>"

    [ -z $1 ] && [ -z $2 ] && [ -z $3 ] && [ -z $4 ]


}

#set server ssh tunnel in client 
ssh_tunnel_pc1_p5901()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 >"

#	The -L switch specifies the port bindings. 
#	In this case we’re binding port 5901 of the remote connection to port 5901 on your local machine. 
#	The -C switch enables compression, 
#	while the -N switch tells ssh that we don’t want to execute a remote command. 
#	The -l switch specifies the remote login name.

	[ ! -z $1 ] && [ ! -z $2 ] && ssh -p 2201 -L 5901:127.0.0.1:5901 -C -N -l $1 $2
	#ssh -L 127.0.0.1:5901:127.0.0.1:5901 -C -N -l $1 $2
	return
}
ssh_tunnel_pc3_p5900()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 >"

#	The -L switch specifies the port bindings. 
#	In this case we’re binding port 5901 of the remote connection to port 5901 on your local machine. 
#	The -C switch enables compression, 
#	while the -N switch tells ssh that we don’t want to execute a remote command. 
#	The -l switch specifies the remote login name.

	[ ! -z $1 ] && [ ! -z $2 ] && ssh -p 2203 -L 5900:127.0.0.1:5900 -C -N -l $1 $2
	#ssh -L 127.0.0.1:5901:127.0.0.1:5901 -C -N -l $1 $2
	return
}
ssh_tunnel_pc4_p5900()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 >"

#	The -L switch specifies the port bindings. 
#	In this case we’re binding port 5901 of the remote connection to port 5901 on your local machine. 
#	The -C switch enables compression, 
#	while the -N switch tells ssh that we don’t want to execute a remote command. 
#	The -l switch specifies the remote login name.

	[ ! -z $1 ] && [ ! -z $2 ] && ssh -p 2204 -L 5900:127.0.0.1:5900 -C -N -l $1 $2
	#ssh -L 127.0.0.1:5901:127.0.0.1:5901 -C -N -l $1 $2
	return
}
ssh_tunnel_pc5_p5900()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 >"

#	The -L switch specifies the port bindings. 
#	In this case we’re binding port 5901 of the remote connection to port 5901 on your local machine. 
#	The -C switch enables compression, 
#	while the -N switch tells ssh that we don’t want to execute a remote command. 
#	The -l switch specifies the remote login name.

	[ ! -z $1 ] && [ ! -z $2 ] && ssh -p 2205 -L 5900:127.0.0.1:5900 -C -N -l $1 $2
	#ssh -L 127.0.0.1:5901:127.0.0.1:5901 -C -N -l $1 $2
	return
}



sshx_pc4()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 >"
    [ ! -z $1 ] && [ ! -z $2 ] && ssh -X -p 2204 $1@$2
}
sshx_pc5()
{
	echo "${FUNCNAME[0]} < usr > < server ipv4 >"
    [ ! -z $1 ] && [ ! -z $2 ] && ssh -X -p 2205 $1@$2
}




