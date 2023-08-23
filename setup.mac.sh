#!/bin/sh

defaults write com.apple.dock autohide-delay -float 0 
defaults write com.apple.dock autohide-time-modifier -float 0.24
defaults write com.apple.dock appswitcher-all-displays -bool true

killall Dock
