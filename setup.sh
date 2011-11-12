#!/bin/bash

path=$(pwd)
target_list=(vimrc vim gvimrc tmux.conf vrapperrc gitconfig gitignore)
for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    echo $target
    if [ -e ~/.$target -o -L ~/.$target ]; then
	echo $target
        mv ~/.$target ~/.$target.orig.back
    fi
    ln -s $path/$target ~/.$target
done

