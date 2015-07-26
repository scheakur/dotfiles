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
    gemrc
)

for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    if [ -e ~/.$target.bak -o -L ~/.$target.bak ]; then
        rm ~/.$target.bak
    fi
done

