#!/bin/bash

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

# Make symbolic links.
path=$(pwd)
target_list=(vimrc vim gvimrc tmux.conf vrapperrc gitconfig gitignore zshrc config/peco)
for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    if [ -e ~/.$target -o -L ~/.$target ]; then
	if [ -e ~/.$target.orig.back -o -L ~/.$target.orig.back ]; then
	    rm -rf ~/.$target.orig.back
	fi
        mv ~/.$target ~/.$target.orig.back
    fi
    ln -s $path/$target ~/.$target
done


# Clone vundle.vim for vim.
if [ -e ~/.vim/bundle/neobundle.vim ]; then
    rm -rf ~/.vim/bundle/neobundle.vim
fi
git clone https://github.com/Shougo/neobundle.vim.git ~/.vim/bundle/neobundle.vim

