#!/bin/bash


netcat_tcp_create_server(){
	echo "${FUNCNAME[0]}"
	nc -lk 0.0.0.0 37580
	return
}

netcat_tcp_send_number(){
	echo "${FUNCNAME[0]}"
	COUNT=0
	while true
	do 	echo "$COUNT" | nc -N 10.0.10.1 37580
		echo "send $COUNT"
		COUNT=$(( $COUNT + 1))
		sleep 0.5
	done 
	return
}

netcat_udp_create_server(){
	echo "${FUNCNAME[0]}"
	nc -u -kl 0.0.0.0 37580
	return
}

netcat_udp_send_number(){
	echo "${FUNCNAME[0]}"
	COUNT=0

	while true
	do 	echo "$COUNT" | nc -cu 10.0.10.1 37580
		echo "send $COUNT"
		COUNT=$(( $COUNT + 1))
		sleep 0.5
	done 


	return
}

