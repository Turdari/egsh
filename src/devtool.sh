#!/bin/bash
CFLOWCONF=/home/$USER/.cflowconf

devtool_cflow_env_show()
{
	echo "<${FUNCNAME[0]}>"	
	if [ -f $CFLOWCONF ] 
	then	cat $CFLOWCONF
	else	echo "Not available : /home/$USER/.cflowconf"
		echo "Call <debug_cflow_env_init>"	
	fi

	return
}

devtool_cflow_env_init()
{
	#do not use single bar "-"
	CFLOW_ENV_DEPTH="--depth=3"
	CFLOW_ENV_TREE=" "
	CFLOW_ENV_INCLUDE="--include _ --include s"
#	CFLOW_ENV_INCLUDE="--include x"
	CFLOW_ENV_REVERSE=" "
	declare -a CFLOW_ENV_UNKNOWN

	
	if [ -f $CFLOWCONF ] && [ $# -eq 0 ]
	then	
		echo "return 0"	
		echo "reason : file exist"	
		return 0 ;
	else 	
		echo "<${FUNCNAME[0]}>"	
		#parse with file and parse with command

		#file part
		if [ -f $CFLOWCONF ] ; then
			for i in $( cat $CFLOWCONF)
			do
				echo $i
			done
		fi

		#command part
		for i in $@
		do
			if $( echo "$i" | grep -qE "\-\-depth" )
			then	CFLOW_ENV_DEPTH=$i
			elif $( echo "$i" | grep -qE "\-\-reverse" )
			then 	CFLOW_ENV_REVERSE=$i 
			elif $( echo "$i" | grep -qE "\-\-\w+" )
			then 	CFLOW_ENV_UNKNOWN+=( $i )
			fi

		done

		echo "print all env variable"
		CFLOW_ENV_ALLT="${CFLOW_ENV_DEPTH} ${CFLOW_ENV_TREE} ${CFLOW_ENV_INCLUDE} ${CFLOW_ENV_REVERSE} ${CFLOW_ENV_UNKNOWN[@]}"
#		echo "depth: "
#		echo ${CFLOW_ENV_DEPTH}
#		echo "tree: "
#		echo ${CFLOW_ENV_TREE}
#		echo "reverse: "
#		echo ${CFLOW_ENV_REVERSE}
#		echo "unknown: "
#		echo ${CFLOW_ENV_UNKNOWN[@]}
		echo $CFLOW_ENV_ALLT
				
		printf "" 			> $CFLOWCONF
		echo	${CFLOW_ENV_ALLT}	>> $CFLOWCONF	
	fi

	return 0
}

devtool_cflow()
{
	echo "${FUNCNAME[0]} <target function> < target dir >"
#	CFLOWFILES=$(cat /tmp/cflowfilelist)		
	[ -z $1 ] && exit -1
	[ -z $2 ] && exit -2
	[ ! -f $CFLOWCONF ] && debug_cflow_env_init


	
	TFILE=$( ls $2 | grep "\.[ch]" | grep -v "trace\.[ch]" | grep -v "\.mod\." ) 

	echo "WARNING! : cflow will fail on static <target function>"
	echo "cflow -m $1 $(cat $CFLOWCONF) $( echo $TFILE | tr '\n' ' ' ) "
	cflow -m $1 $(cat $CFLOWCONF) $( echo $TFILE | tr '\n' ' ' ) 

	return 0
}

devtool_kernel_file_extract()
{
	echo "<${FUNCNAME[0]}> <kernel directory>"

	[ -z $1 ] && exit
	sudo apt-get install -y cscope 
	sudo apt-get install -y ctags

#	https://stackoverflow.com/questions/33676829/vim-configuration-for-linux-kernel-development
	#make O=. ARCH=arm COMPILED_SOURCE=1 cscope tags
	make O=$1 ARCH=arm cscope tags

	return
}

devtool_cflow_new()
{
	echo "<${FUNCNAME[0]}>"
	CMD_ARG=( $@ )

	if ( echo "$1" | grep -qP "[a-zA-Z_-]+" ) ; then	
		#echo "${CMD_ARG[@]:2}"
		echo "cflow -m ${CMD_ARG[@]} $( find $PWD -type f | grep "\.[ch]$" )"
		cflow -m ${CMD_ARG[@]} $( find $PWD -type f | grep "\.[ch]$" )
	else
		echo "Usage:"
		printf "\t${FUNCNAME[0]} <function name> [cflow option] \n"
	fi

	return
}

devtool_sed_atob()
{
	echo "<${FUNCNAME[0]}>"
	CMD_ARG=( $@ )

    if [ ${#CMD_ARG[@]} -ge 3 ]
    then :
        sed -i "s/${CMD_ARG[0]}/${CMD_ARG[1]}/g" ${CMD_ARG[@]:2}
    else :
        echo "Usage:"
		printf "\t${FUNCNAME[0]} <A> <B> <files...> \n" 
    fi
    
}



