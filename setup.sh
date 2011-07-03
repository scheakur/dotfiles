#!/bin/sh

path=$(pwd)

for target in {vimrc, vim};
do
    mv ~/.$target ~/.$target.orig.back
    ln -s $path/$target ~/.$target
done
