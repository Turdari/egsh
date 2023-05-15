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
ESYNC_SHELL_SOURCE_DIR=$EGSH_CTX_ESYNC_LIB/sh


RV=0

for i in $@
do
    case $i in
    	dosync )
            if ( ! diff -s $ESYNCHOME/.vimrc $HOME/.vimrc  > /dev/null ) ; then
                echo "SYNC .vimrc "
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
#            if ( ! diff -s $ESYNCHOME/.tmux.conf $HOME/.tmux.conf > /dev/null ) ; then
#                echo "SYNC .tmux.conf"
#                read -p "Do you want to overwrite? (y/n)" yn
#                case $yn in
#                    y | Y )
#                        rm -f $HOME/.tmux.conf
#                        ln -s $ESYNCHOME/.tmux.conf $HOME/.tmux.conf
#                    ;;
#                    n | N )
#                    ;;
#                    * )
#                    ;;
#                esac
#            fi
#            if ( ! grep -q "EGSH" $HOME/.bashrc ) ; then
#                echo "SYNC .bashrc egsh shsrc "
#                read -p "Do you want to overwrite? (y/n)" yn
#                case $yn in
#                    y | Y )
#                        echo "##EGSH##" >> $HOME/.bashrc
#                        echo "for f in \$(find $EGSH_USR_SHSRC -type f ) ; do : ; source \$f ; done" >> $HOME/.bashrc
#                    ;;
#                    n | N )
#                    ;;
#                    * )
#                    ;;
#                esac
#            fi
    	;;
    	issync )
            if ( ! diff -s $ESYNCHOME/.vimrc $HOME/.vimrc > /dev/null ) ; then
                echo ".vimrc diff!"
                RV=1;
            fi
#            if ( ! diff -s $ESYNCHOME/.tmux.conf $HOME/.tmux.conf > /dev/null ) ; then
#                echo ".tmux.conf diff!"
#                RV=1;
#            fi
#            if ( ! grep -q "EGSH" $HOME/.bashrc ) ; then
#                echo ".bashrc egsh shsrc not registered."
#                RV=1;
#            fi
        ;;
        * )
        ;;
    esac
done

exit $RV;
