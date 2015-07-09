#!/bin/bash

target_list=(
    vimrc
    vim
    gvimrc
    tmux.conf
    tmux
    vrapperrc
    gitconfig
    gitignore
    profile
    zshrc
    zshenv
    config/peco
    npmrc
)

for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    if [ -e ~/.$target.orig.back -o -L ~/.$target.orig.back ]; then
        rm ~/.$target.orig.back
    fi
done

