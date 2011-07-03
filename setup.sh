#!/bin/sh

path=$(pwd)
target_list=(vimrc vim)
for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    if [ -e ~/.$target ]; then
        mv ~/.$target ~/.$target.orig.back
    fi
    ln -s $path/$target ~/.$target
done
