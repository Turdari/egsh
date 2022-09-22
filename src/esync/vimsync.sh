#!/bin/bash

export EGSH_DIR ;
export EGSH_VERSION ;
export EGSH_USR_DIR ;
export EGSH_USR_INC ;
export EGSH_USR_SHSRC ;
export EGSH_USR_ESYNC ;
export EGSH_USR_DCMD ;
export EGSH_CTX_ESYNC ;
export EGSH_CTX_ESYNC_LIB ;    
export EGSH_CTX_DCMD_LIB ;
export EGSH_CTX_PKG_LIB ;

#CMDARG=( $@ )

ESYNCHOME=$EGSH_CTX_ESYNC_LIB/home
ESYNCVIMBUNDLE=$ESYNCHOME/.vim/bundle

VIMBUNDLE=$HOME/.vim/bundle

RV=0

for i in $@
do
    case $i in
    	dosync )
            if [ ! -d  $VIMBUNDLE/tagbar ] ; then
                echo "SYNC tagbar "
                read -p "Do you want to overwrite? (y/n)" yn
                case $yn in
                    y | Y )
                        #sudo chmod -R 777 $ESYNCVIMBUNDLE/tagbar/*
                        sudo rm -fr $VIMBUNDLE/tagbar
                        cp -r $ESYNCVIMBUNDLE/tagbar $VIMBUNDLE/tagbar 
                    ;;
                    n | N )
                    ;;
                    * )
                    ;;
                esac
            fi
            if [ ! -d  $VIMBUNDLE/nerdtree ] ; then
                echo "SYNC nerdtree"
                read -p "Do you want to overwrite? (y/n)" yn
                case $yn in
                    y | Y )
                        #sudo chmod -R 777 $ESYNCVIMBUNDLE/nerdtree/*
                        sudo rm -fr $VIMBUNDLE/nerdtree
                        cp -r $ESYNCVIMBUNDLE/nerdtree $VIMBUNDLE/nerdtree
                    ;;
                    n | N )
                    ;;
                    * )
                    ;;
                esac
            fi
            if [ ! -d  $VIMBUNDLE/sync-term-cwd ] || [ ! -f $EGSH_USR_SHSRC/synctermcwd.sh ]; then
                echo "SYNC sync-term-cwd"
                read -p "Do you want to overwrite? (y/n)" yn
                case $yn in
                    y | Y )
                        #sudo chmod -R 777 $ESYNCVIMBUNDLE/sync-term-cwd/*
                        sudo rm -fr $VIMBUNDLE/sync-term-cwd
                        rm $EGSH_USR_SHSRC/synctermcwd.sh
                        cp -r $ESYNCVIMBUNDLE/sync-term-cwd $VIMBUNDLE/sync-term-cwd
                        ln -s $ESYNCVIMBUNDLE/sync-term-cwd/macros/synctermcwd.sh $EGSH_USR_SHSRC/synctermcwd.sh
                    ;;
                    n | N )
                    ;;
                    * )
                    ;;
                esac
            fi
    	;;
    	issync )
            if [ ! -d  $VIMBUNDLE/tagbar ] ; then
                echo "tagbar not exist!"
                RV=1;
            fi
            if [ ! -d  $VIMBUNDLE/nerdtree ] ; then
                echo "nerdtree not exist"
                RV=1;
            fi
            if [ ! -d  $VIMBUNDLE/sync-term-cwd ] ; then
                echo "sync-term-cwd not exist"
                RV=1;
            fi
            if [ ! -f  $EGSH_USR_SHSRC/synctermcwd.sh ] ; then
                echo "synctermcwd.sh not exist"
                RV=1;
            fi
        ;;
        * )
        ;;
    esac
done

exit $RV;
