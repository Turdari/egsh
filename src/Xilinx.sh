#!/bin/bash

# https://support.xilinx.com/s/question/0D52E00006hpQD0SAM/vitis-20202-install-with-ubuntu-2004lts-hangs-on-generating-installed-device-list?language=zh_CN

#As written at: https://support.xilinx.com/s/article/63794?language=en_US :
#The following packages were reported by customers as needing to be installed on Ubuntu 64bit to get the Documentation Navigator running.
#You can install the following packages using apt-get (not just for the Documentation Navigator)
#
#sudo apt-get install libstdc++6:i386
#sudo apt-get install libgtk2.0-0:i386
#sudo apt-get install dpkg-dev:i386
#
#The SDK requires gmake, but Ubuntu only contains make (it is the same binary, but a different filename).
#
#gmake needs to be created as a link:
#
#sudo ln -s /usr/bin/make /usr/bin/gmake
#
#On a minimal Ubuntu install you will need to install pip to work with Python packages:
#
#apt install python3-pip
#
#Install these missing Ubuntu packages:
#apt install libtinfo5 libncurses5
#Without libtinfo5 Vivado will not start.
#Without libncurses5 simulation fails.
#After running the Vivado installer on Linux you will need to install cable drivers as root.
#If you do not install cable drivers you will not be able to connect to boards.
#This is the case for all Linux installs, not just Ubuntu.
#
#Installation steps:
#cd /opt/Xilinx/Vivado/2019.2
## cd into the drivers directory (the script MUST be run there)
#cd data/xicom/cable_drivers/lin64/install_script/install_drivers
## run the cable installer with root privileges
#sudo ./install_drivers




xilinx_show_install_list(){
	echo "<Package reported for ubuntu>"
	echo "#libtinfo5 Vivado will not start"
	echo "#libncurses5 simulation fails"
	echo "sudo apt-get install libstdc++6:i386"
	echo "sudo apt-get install libgtk2.0-0:i386"
	echo "sudo apt-get install dpkg-dev:i386"
	echo "sudo ln -s /usr/bin/make /usr/bin/gmake"
	echo "sudo apt install python3-pip"
	echo "sudo apt install libtinfo5 libncurses5"
	echo ""	
	echo "<cable drivers (for all linux)> "
	echo "# change directory to your Vivado install, for example:"
	echo "cd /opt/Xilinx/Vivado/2019.2"
	echo "# cd into the drivers directory (the script MUST be run there)"
	echo "cd data/xicom/cable_drivers/lin64/install_script/install_drivers"
	echo "# run the cable installer with root privileges"
	echo "sudo ./install_drivers"

	return 
}

install_ubuntu_additional(){
	sudo apt-get -y install libstdc++6:i386
	sudo apt-get -y install libgtk2.0-0:i386
	sudo apt-get -y install dpkg-dev:i386
	sudo apt-get -y install python3-pip
	sudo apt-get -y install libtinfo5 libncurses5
	sudo ln -s /usr/bin/make /usr/bin/gmake

	return
}

setup_TCP_into_current_directory(){

	if [ $# -eq 2 ] ; then

		if [ -d $1 ] && [ -d $2 ] ; 
		then
			VAR=( $( ls $( realpath $2 ) | grep "\.c" ) )
			#echo ${VAR[@]}
			
			for i in ${VAR[@]}
			do cp $(realpath $2)/$i $1
			done

			return 0
		fi
	fi

	echo "${FUNCNAME[0]} <Target DIR> <FreeRTOS+TCP DIR>"
	return
}


xilinx_usb_setup()
{
	echo "${FUNCNAME[0]}"
    stty -F /dev/ttyACM0 raw
    stty -F /dev/ttyACM0 -echo -echoe -echok
    return
}

xilinx_usb_setup2()
{
	echo "${FUNCNAME[0]}"
    stty -F /dev/ttyACM1 raw
    stty -F /dev/ttyACM1 -echo -echoe -echok
    return
}

xilinx_usb_loop_create()
{
	echo "${FUNCNAME[0]}"
    stty -F /dev/ttyACM0 raw
    stty -F /dev/ttyACM0 -echo -echoe -echok
    cat /dev/ttyACM0 > /dev/ttyACM0
    return
}


function ignore_ctrlc() {
        echo "trap works"
#        kill $PID1
        kill $PID2
}

xilinx_nc_loop_create()
{

    trap ignore_ctrlc SIGINT 
	echo "${FUNCNAME[0]}"     
    cat > tpipe &
    PID2=$(echo $!)
#    PID1=$(echo $!)
    cat tpipe | netcat 10.0.10.2 5001 

#    echo $PID1
#    echo $PID2

#    netcat -ul 4321


    return
}

CDCACM_COMMON_DIR=$HOME/cdcacm
xilinx_cdcacm_modules_create(){	
	echo "<${FUNCNAME[0]}>"
    CDCACM_INSTALL_MOD_PATH=/lib/modules/$(uname -r)
    #temoporary implementation for kali
	cd $CDCACM_COMMON_DIR
	CDCACM_REAL_DIR=$(realpath .)

	#echo "target : $CDCACM_REAL_DIR"


	sudo make -C /lib/modules/$(uname -r)/build M=$CDCACM_REAL_DIR modules
	echo "<DONE>"
	return
}

xilinx_cdcacm_modules_install()
{
	cd $CDCACM_COMMON_DIR
	CDCACM_REAL_DIR=$(realpath .)

	sudo make \
		-C /lib/modules/$(uname -r)/build \
		M=$CDCACM_REAL_DIR \
		KERNELRELEASE=$(uname -r) \
		modules_install

	sudo depmod -a
	return
}
