#!/bin/bash


patch_compareNcreate()
{
	echo "<${FUNCNAME[0]}> $1 $2 $3"

	#do not check file validity
	#Can work only when coresponding directory exsist

	if [ ! -z $1 ] && [ ! -z $2 ] ; then
		PATCHPATH=$PWD/egpatch
		[ ! -z $3 ] && [ -d $3 ] && PATCHPATH=$(realpath $3)
		#[ -d $3 ] && PATCHPATH=$(realpath $3) || return
		
		#create directory first 
		#applied 
		[ -d $( dirname $PATCHPATH/$1 ) ] || mkdir -p $( dirname $PATCHPATH/$1 )

		diff -u $1 $2 > $PATCHPATH/$1.diff
		[ $? -eq 0 ] && rm $PATCHPATH/$1.diff

	else 	echo "Parameter Invalid"
		echo "Usage : ${FUNCNAME[0]} <old src> <new src> [patch result dir]"
	fi 

	return
}

patch_compareNcreate_dir()
{
	echo "<${FUNCNAME[0]}>"

#	#Solution 1 
#	cp -R --attributes-only SOURCE DEST
#	cp -R --attributes-only --preserve=all --parents -v SOURCE DEST
#	find DEST -type f -exec rm {} \;
#	#Solution 2
#	cd /path/to/directories &&
#	find . -type d -exec mkdir -p -- /path/to/backup/{} \;
#	#Create target directory first
#	cp -R --attributes-only --preserve=all $1 $PATCHPATH

	#check directory validity
	if [ ! -z $1 ] && [ ! -z $2 ] && [ -d $1 ] && [ -d $2 ]
	then 	echo "Directory given, start processing"
		for i in  $(find -L $1 -type f ); do	
		OFILE+=( $( realpath --relative-to="$1" $i ) )
		done
		for i in  $(find -L $2 -type f ); do	
		NFILE+=( $( realpath --relative-to="$2" $i ) )
		done

#		error code!
#		OFILE=( $(find -L $1 -type f | sed -r "s/$1\///g" ) ) 
#		NFILE=( $(find -L $2 -type f | sed -r "s/$2\///g" ) )

#		echo "Original files : ${OFILE[@]}"
#		echo "New files : ${NFILE[@]}"

		#set patch result directory
		PATCHPATH=$PWD/egpatch
		[ ! -z $3 ] && [ -d $3 ] && PATCHPATH=$(realpath $3)
		rm -rf $PATCHPATH/$1
		find -L $1 -type d -exec mkdir -p -- $PATCHPATH/{} \;


		for i in ${OFILE[@]} 
		do
			if echo ${NFILE[@]} | grep -q -w "$i"
			then 	#echo "NEWF have $i"
				patch_compareNcreate $1/$i $2/$i $PATCHPATH
			else 	echo "NEWF don't have $i"
			fi
		done

	else 	echo "Usage : ${FUNCNAME[0]} <old dir> <new dir> [ backup dir ]"
	fi 

	return
}

patch_apply2dir()
{
	echo "<${FUNCNAME[0]}>"
	if [ ! -z $1 ] && [ ! -z $2 ] && [ -d $1 ] && [ -d $2 ]
	then 	echo "Directory given, start processing"
		for i in  $(find -L $1 -type f ); do	
		OFILE+=( $( realpath --relative-to="$1" $i ) )
		done

		for i in  $(find -L $2 -type f ); do	
		PFILE+=( $( realpath --relative-to="$2" $i ) )
		done

#		echo "Original files : ${OFILE[@]}"
#		echo "New files : ${PFILE[@]}"
	
		for i in ${PFILE[@]} 
		do
			CMPSTR=$( echo $i | sed -r 's/\.diff//g' )
			if echo ${OFILE[@]} | grep -q -w "$CMPSTR"
			then 	echo "Patch $i available"
				patch $3 $1/$CMPSTR $2/$i
			else 	echo "Patch $i not available"
			fi
		done


	else 	echo "Usage : ${FUNCNAME[0]} <source dir> <patch files dir> [option]"
	fi

	return
}



