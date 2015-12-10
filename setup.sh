#!/bin/bash

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

# Make symbolic links.
path=$(pwd)

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
    eslintrc
)

for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    if [ -e ~/.$target -o -L ~/.$target ]; then
        if [ -e ~/.$target.bak -o -L ~/.$target.bak ]; then
            rm -rf ~/.$target.bak
        fi
        mv ~/.$target ~/.$target.bak
    fi
    ln -s $path/$target ~/.$target
done


# Clone vim-plug for vim.
if [ -e ~/.vim/bundle/vim-plug ]; then
    rm -rf ~/.vim/bundle/vim-plug
fi

git clone https://github.com/junegunn/vim-plug.git  ~/.vim/bundle/vim-plug/autoload

