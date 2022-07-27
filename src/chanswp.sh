#!/bin/bash


chanswp_5_11_RP()
{
	echo "${FUNCNAME[0]}"

	declare -a CHAN
	declare -a FREQ
	
	CHAN+=("5" "11")
	FREQ+=("2432" "2462")

	#OPTION="bandwidth=20"
	COUNT=0

	echo "first approach may fail due to same channel"	
	while true
	do	sleep 1 ;
#		echo "$COUNT: ${CHAN[$COUNT]} ${FREQ[$COUNT]}"
#		echo "$OPTION"
		sudo hostapd_cli chan_switch ${CHAN[$COUNT]} ${FREQ[$COUNT]} $OPTION	

		COUNT=$(( ($COUNT + 1) % 2 ))
	done

	return
}

chanswp_3to11()
{
	echo "${FUNCNAME[0]} <cs_count> <delay>"

#	declare -a CHAN
#	declare -a FREQ

	
	[ -z $1 ] && exit 1
	[ -z $2 ] && exit 1

	echo "started"	
	CSCNT=$1
	FREQ+=("2422" "2432" "2442" "2452" "2462")

	#OPTION+="bandwidth=20"
	OPTION+="blocktx"
	MAXCOUNT=5
	COUNT=0

	echo "first approach may fail due to same channel"	
	while true
	do	sleep $2 ;
		#echo "Switch to: $CSCNT ${FREQ[$COUNT]}"
		echo "sudo hostapd_cli chan_switch $CSCNT ${FREQ[$COUNT]} $OPTION"
		sudo hostapd_cli chan_switch $CSCNT ${FREQ[$COUNT]} $OPTION	

		COUNT=$(( ($COUNT + 1) % $MAXCOUNT ))
	done

	return
}



chanswp_wpa_supplicant_init(){
	echo "${FUNCNAME[0]}"
	sudo airmon-ng check kill
	sudo wpa_supplicant -D nl80211 -i wlan4 -c wpa_supplicant.conf -B
	return
}

chanswp_env_fini(){
	echo "${FUNCNAME[0]}"
	sudo airmon-ng check kill
	sudo modprobe -r ath9k_htc
	return
}


