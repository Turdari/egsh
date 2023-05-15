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

#Fixme
# Only in case when .local/bin is not in the environment 
# but it can cause error. so should be fixed later
bashrc_file="$HOME/.bashrc"
bin_path="$HOME/.local/bin"
if [[ ":$PATH:" != *":$bin_path:"* ]]; then
    echo "Adding $bin_path to PATH in $bashrc_file"
    echo "##EGSH install##" >> "$bashrc_file"
    echo "export PATH=\$PATH:$bin_path" >> "$bashrc_file"
else
    echo "$bin_path is already in PATH"
fi

#INS_DIR_LIB=/usr/local/lib
#INS_DIR_BIN=/usr/local/bin
INS_DIR_LIB=$HOME/.local/share
INS_DIR_BIN=$HOME/.local/bin

# check directory
mkdir -p "$INS_DIR_BIN" 

rm -rf $INS_DIR_LIB/egsh
rm -rf $INS_DIR_BIN/egsh

git clone $EGSH_DIR $INS_DIR_LIB/egsh
git -C $INS_DIR_LIB/egsh remote set-url origin https://github.com/Turdari/egsh.git
ln -s $INS_DIR_LIB/egsh/egsh $INS_DIR_BIN/egsh
