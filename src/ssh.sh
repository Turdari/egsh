#!/bin/bash

DEFAULT_IP="121.126.215.86"
#115.144.233.222
ssh_tunnel() 
{
    # Check if the function was called with exactly three arguments
    if [ "$#" -ne 4 ]; then
        # If not, print a usage message and return with an error status
        echo "Usage: ${FUNCNAME[0]} <user> <server_ipv4:port> <target_port> <local_port>"
        return 1
    fi

    # Define variables that are local to the function
    local user="$1"

    # Save old IFS value and set new one to ":"
    local oldifs="$IFS"
    IFS=":"
    local server_info=($2)
    IFS="$oldifs"

    local server="${server_info[0]}"
    local ssh_server_port="${server_info[1]:-22}"  # Default SSH port is 22 if not provided
    local target_port="$3"
    local local_port="$4"

    # The command to create the SSH tunnel
    # -nNT makes SSH run in the background without executing a remote command. This is necessary for setting up a tunnel
    # -L $local_port:localhost:$local_port specifies the details of the tunnel. It means that connections to $local_port on the local host are to be forwarded to the remote (server) host at the same port
    ssh -p $ssh_server_port -nNT -L $local_port:localhost:$target_port $user@$server
}
ssh_reverse_tunnel() 
{
    # Check if the function was called with exactly two arguments
    if [ "$#" -ne 4 ]; then
        # If not, print a usage message and return with an error status
        echo "Usage: ${FUNCNAME[0]} <user> <server_ipv4:sshport> <target-port> <local-port>"
        return 1
    fi

    # Define variables that are local to the function
    # This prevents them from interfering with any global variables of the same name
    local user="$1"

    # Save old IFS value and set new one to ":"
    local oldifs="$IFS"
    IFS=":"
    local server_info=($2)
    IFS="$oldifs"
    
    local server="${server_info[0]}"
    local ssh_server_port="${server_info[1]:-22}"
    local target_port="$3"
    local local_port="$4"
    # The command to create the reverse SSH tunnel
    # -nNT makes SSH run in the background without executing a remote command. This is necessary for setting up a tunnel
    # -R $target_port:localhost:$local_port specifies the details of the reverse tunnel.
    # It means that connections to $target_port on the remote (server) host are to be forwarded to localhost at $local_port
    ssh -p $ssh_server_port -nNT -R $target_port:localhost:$local_port $user@$server 
}
sshx_app() 
{
    # Check if the function was called with exactly three arguments
    if [ "$#" -lt 2 ]; then
        # If not, print a usage message and return with an error status
        echo "Usage: ${FUNCNAME[0]} <user> <server_ipv4:ssh_port> [app_name]"
        return 1
    fi

    # Define variables that are local to the function
    local user="$1"

    # Save old IFS value and set new one to ":"
    local oldifs="$IFS"
    IFS=":"
    local server_info=($2)
    IFS="$oldifs"

    local server="${server_info[0]}"
    local ssh_server_port="${server_info[1]:-22}"  # Default SSH port is 22 if not provided
    local app_name="$3"

    # The command to create an SSH connection and run the specified app
    ssh -X -p $ssh_server_port $user@$server $app_name
}

#set server ssh tunnel in client 
ssh_tunnel_pc1()
{
	echo "${FUNCNAME[0]}"
    ssh_tunnel turi ${DEFAULT_IP}:2201 5900 5901
	return
}
ssh_tunnel_pc3()
{
	echo "${FUNCNAME[0]}"
    ssh_tunnel turi ${DEFAULT_IP}:2203 5900 5903
	return
}
ssh_tunnel_pc4()
{
	echo "${FUNCNAME[0]} "
    ssh_tunnel turi ${DEFAULT_IP}:2204 5900 5904
    return
}
ssh_tunnel_pc5()
{
	echo "${FUNCNAME[0]} "
    ssh_tunnel turi ${DEFAULT_IP}:2205 5900 5905
	return
}

ssh_tunnel_pc6()
{
	echo "${FUNCNAME[0]} "
    ssh_tunnel turi ${DEFAULT_IP}:2206 5900 5906
	return
}


sshx_pc1()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi ${DEFAULT_IP}:2201 $1
}
sshx_pc2()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi ${DEFAULT_IP}:2202 $1
}
sshx_pc3()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi ${DEFAULT_IP}:2203 $1
}
sshx_pc4()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi ${DEFAULT_IP}:2204 $1
}
sshx_pc5()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi ${DEFAULT_IP}:2205 $1
}

sshx_local_pc1()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi 192.168.200.1:2201 $1
}
sshx_local_pc2()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi 192.168.200.2:2202 $1
}
sshx_local_pc3()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi 192.168.200.3:2203 $1
}
sshx_local_pc4()
{

	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi 192.168.200.4:2204 $1
}
sshx_local_pc5()
{
	echo "${FUNCNAME[0]} [appname]"
    sshx_app turi 192.168.200.5:2205 $1
}



