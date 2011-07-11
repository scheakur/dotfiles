#!/bin/bash

target_list=(vimrc vim gvimrc tmux.conf)
for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    if [ -e ~/.$target.orig.back ]; then
        rm ~/.$target.orig.back
    fi
done

