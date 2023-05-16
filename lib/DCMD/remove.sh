#!/bin/bash

#echo "works? :$@"
echo "<EGSH remove.sh>"
#echo "script location : $0"
#echo "target location : $1"
sleep 1
ARGS=( $@  )
echo "remove list : ${ARGS[@]}"
sudo rm -rf ${ARGS[@]}
#rm -rf $INS_DIR_LIB/egsh
echo "DONE!"
