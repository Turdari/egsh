#!/bin/bash

export EGSH_DIR ;
export EGSH_VERSION ;
export EGSH_USR_DIR ;
export EGSH_USR_INC ;
export EGSH_USR_ESYNC ;
export EGSH_USR_DCMD ;
export EGSH_CTX_ESYNC ;
export EGSH_CTX_ESYNC_LIB ;    
export EGSH_CTX_DCMD_LIB ;
export EGSH_CTX_PKG_LIB ;

#CMDARG=( $@ )

ESYNCHOME=$EGSH_CTX_ESYNC_LIB/home
RV=0

for i in $@
do
    case $i in
    	dosync )
            if ( ! diff -s $ESYNCHOME/.vimrc $HOME/.vimrc  > /dev/null ) ; then
                echo ".vimrc diff!"
                read -p "Do you want to overwrite? (y/n)" yn
                case $yn in
                    y | Y )
                        rm -f $HOME/.vimrc
                        ln -s $ESYNCHOME/.vimrc $HOME/.vimrc
                    ;;
                    n | N )
                    ;;
                    * )
                    ;;
                esac
            fi
            if ( ! diff -s $ESYNCHOME/.tmux.conf $HOME/.tmux.conf > /dev/null ) ; then
                echo ".tmux.conf diff!"
                read -p "Do you want to overwrite? (y/n)" yn
                case $yn in
                    y | Y )
                        rm -f $HOME/.tmux.conf
                        ln -s $ESYNCHOME/.tmux.conf $HOME/.tmux.conf
                    ;;
                    n | N )
                    ;;
                    * )
                    ;;
                esac
            fi
    	;;
    	issync )
            if ( ! diff -s $ESYNCHOME/.vimrc $HOME/.vimrc > /dev/null ) ; then
                echo ".vimrc diff!"
                RV=1;
            fi
            if ( ! diff -s $ESYNCHOME/.tmux.conf $HOME/.tmux.conf > /dev/null ) ; then
                echo ".tmux.conf diff!"
                RV=1;
            fi
        ;;
        * )
        ;;
    esac
done

exit $RV;
