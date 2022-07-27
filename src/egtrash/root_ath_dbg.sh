#!/bin/bash

DEBUGFS_DIR=/sys/kernel/debug


root_athd_set()
{
	echo "${FUNCNAME[0]}"
	root_athd_syslog_set phy1 0xFFFFFFFF

	return
}

root_athd_unset()
{
	echo "${FUNCNAME[0]}"
	root_athd_syslog_unset

	return
}

root_athd_syslog_set_debugfs()
{
	echo "${FUNCNAME[0]} <phyx> [hex(format:0xXXXXXXXX)]"
	DIR="/sys/kernel/debug/ieee80211/$1/ath9k_htc"

	if [ -z $1 ]
	then 	echo "<table>"
		echo "ATH_DBG_RESET= 0x00000001,"
		echo "ATH_DBG_QUEUE= 0x00000002,"
		echo "ATH_DBG_EEPROM= 0x00000004,"
		echo "ATH_DBG_CALIBRATE= 0x00000008,"
		echo "ATH_DBG_INTERRUPT= 0x00000010,"
		echo "ATH_DBG_REGULATORY= 0x00000020,"
		echo "ATH_DBG_ANI= 0x00000040,"
		echo "ATH_DBG_XMIT= 0x00000080,"
		echo "ATH_DBG_BEACON= 0x00000100,"
		echo "ATH_DBG_CONFIG= 0x00000200,"
		echo "ATH_DBG_FATAL= 0x00000400,"
		echo "ATH_DBG_PS= 0x00000800,"
		echo "ATH_DBG_BTCOEX= 0x00001000,"
		echo "ATH_DBG_WMI= 0x00002000,"
		echo "ATH_DBG_BSTUCK= 0x00004000,"
		echo "ATH_DBG_MCI= 0x00008000,"
		echo "ATH_DBG_DFS= 0x00010000,"
		echo "ATH_DBG_WOW= 0x00020000,"
		echo "ATH_DBG_CHAN_CTX= 0x00040000,"
		echo "ATH_DBG_DYNACK= 0x00080000,"
		echo "ATH_DBG_SPECTRAL_SCAN= 0x00100000,"
		echo "ATH_DBG_ANY= 0xffffffff"
	fi

	[ -z $2 ] && HEX="0x00000400" || HEX=$2
	[ -f $DIR/debug ] && echo "<check succ>" || exit -1
	echo $HEX > $DIR/debug
	echo "changed to $(cat $DIR/debug)"



	return
}


root_athd_syslog_prinklevel_set()
{
	echo "${FUNCNAME[0]}"
	echo 8 > /proc/sys/kernel/printk
	echo "current printk level :"
	cat /proc/sys/kernel/printk
	return
}

root_athd_syslog_printklevel_unset()
{
	echo "${FUNCNAME[0]}"
	echo 7 > /proc/sys/kernel/printk
	echo "current printk level :"
	cat /proc/sys/kernel/printk
	return
}

root_athd_syslog_unset()
{
	echo "${FUNCNAME[0]}"
	root_athd_syslog_set phy1
	return
}

root_athd_uevent_set()
{
	echo "${FUNCNAME[0]}"

	EVENT_DIR=$DEBUGFS_DIR/tracing/events
	#echo "$EVENT_DIR"
	echo 1 > $EVENT_DIR/cfg80211/enable
	echo 1 > $EVENT_DIR/mac80211/enable
	root_athd_uevent_set_filter

	return
}

root_athd_uevent_unset()
{
	echo "${FUNCNAME[0]}"

	EVENT_DIR=$DEBUGFS_DIR/tracing/events
	#echo "$EVENT_DIR"
	echo 0 > $EVENT_DIR/cfg80211/enable
	echo 0 > $EVENT_DIR/mac80211/enable

	return
}


root_athd_uevent_catpipe()
{
	echo "${FUNCNAME[0]}"
	TRACE_DIR=$DEBUGFS_DIR/tracing
	cd $TRACE_DIR
	pwd
	cat trace_pipe
	return
}

root_athd_uevent_set_filter()
{
	echo "${FUNCNAME[0]}"

	EVENT_DIR=$DEBUGFS_DIR/tracing/events
	#echo "$EVENT_DIR"
	echo 0 > $EVENT_DIR/cfg80211/cfg80211_rx_mgmt/enable
	echo 0 > $EVENT_DIR/cfg80211/cfg80211_return_bool/enable

	return
}

