#!/bin/bash


chanswp_7_11_RP()
{
	echo "${FUNCNAME[0]}"

	declare -a CHAN
	declare -a FREQ
	
	CHAN+=("7" "11")
	FREQ+=("2442" "2462")

	OPTION="bandwidth=20"
	COUNT=0


	echo "first approach may fail due to same channel"	
	while true
	do	sleep 4 ;
#		echo "$COUNT: ${CHAN[$COUNT]} ${FREQ[$COUNT]}"
#		echo "$OPTION"
		sudo hostapd_cli chan_switch ${CHAN[$COUNT]} ${FREQ[$COUNT]} $OPTION	

		COUNT=$(( ($COUNT + 1) % 2 ))
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


