#!/bin/sh

target_list=(
    Applications
    Desktop
    Documents
    Downloads
    Movies
    Music
    Pictures
    Private
    Public
    Work
    tmp
)

for (( i = 0; i < ${#target_list[@]}; i++ ))
do
    target=${target_list[i]}
    sudo rm -rf ~/$target
    ln -si ~/Dropbox/$target ~/$target
done

killall Finder


defaults write com.apple.dock autohide-delay -float 0 
defaults write com.apple.dock autohide-time-modifier -float 0.24

killall Dock
