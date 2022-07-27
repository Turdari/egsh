#!/bin/bash

pingNperf_ipv4(){
	echo "${FUNCNAME[0]} <ipv4 ADDRESS> <TESTTIME> [suffix]"

	[ -z $1 ] && ! ( echo "$1" | grep -P "\d+\.\d+\.\d+\.\d+" ) && exit -1 
	[ -z $2 ] && ! ( echo "$2" | grep -P "\d+" ) && exit -1 

#	echo "$1" | grep -P "\d+\.\d+\.\d+\.\d+"
#	echo 1st return $?
#	echo "$2" | grep -P "\d+"
#	echo 2nd return $?
	#how to set it up in background and catch signal to stop...
	[ ! -z $3 ] && SUFFIXHEAD=$3_
	PINGF_SUFFIX=${SUFFIXHEAD}$(date | cut -d ' ' -f 2,3,4 | tr ' ' '-').txt
	PERFF_SUFFIX=${SUFFIXHEAD}$(date | cut -d ' ' -f 2,3,4 | tr ' ' '-').txt

	TIMEOUT="FALSE"
	echo "ping -W 1 -c $2 -q $1 > ping_$PINGF_SUFFIX & "
	ping -W 1 -c $2 -q $1 > ping_$PINGF_SUFFIX & 
	PINGID=$!
	echo "iperf -c $1 -t $2 > iperf_$PERFF_SUFFIX &"
	iperf -c $1 -t $2 > iperf_$PERFF_SUFFIX &
	PERFID=$!

	

	echo "<Test start>"
#	echo "finish test manually : q "
#	bash -c "sleep $2 ; powershell.exe '[console]::beep(2000,300)' ; echo done! " &
	sleep $2
	powershell.exe '[console]::beep(2000,300)'
	echo "<Test end>"
#	while read var ;
#	do :
#		if [ -z $line ] ; 
#		then 	:
##			if [ $TIMEOUT == "TRUE" ] ; 
##			then echo "Normal termination timeout"
##			fi
#		else 
#			echo "read '$line'";
#			if [ $line == "q" ] || [ $line == "quit" ] ; then
#				echo "kill process and quit"
#				kill $PINGID
#				kill $PERFID	
#				break;
#			fi
#		fi
#	done
#
#	echo "<Test end>"
}




