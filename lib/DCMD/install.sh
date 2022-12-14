#!/bin/bash
export EGSH_DIR ;
export EGSH_VERSION ;
export EGSH_USR_DIR ;
export EGSH_USR_INC ;
export EGSH_USR_ESYNC ;
export EGSH_USR_DCMD ;
export EGSH_CTX_SRC ;
export EGSH_CTX_ESYNC ;
export EGSH_CTX_ESYNC_LIB ;    
export EGSH_CTX_DCMD_LIB ;
export EGSH_CTX_PKG_LIB ;


INS_DIR_LIB=/usr/local/lib
INS_DIR_BIN=/usr/local/bin

sudo rm -rf $INS_DIR_LIB/egsh
sudo rm -rf $INS_DIR_BIN/egsh

sudo git clone $EGSH_DIR $INS_DIR_LIB/egsh
sudo git -C $INS_DIR_LIB/egsh remote set-url origin https://github.com/Turdari/egsh.git
sudo ln -s $INS_DIR_LIB/egsh/egsh $INS_DIR_BIN
