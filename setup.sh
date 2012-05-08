#!/bin/bash

# Make symbolic links.
path=$(pwd)
target_list=(vimrc vim gvimrc tmux.conf vrapperrc gitconfig gitignore zshrc)
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
if [ -e ~/.vim/bundle/vundle ]; then
    rm -rf ~/.vim/bundle/vundle
fi
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

