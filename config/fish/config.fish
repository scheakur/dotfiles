set --export GOPATH $HOME
set PATH $GOPATH/bin $PATH
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.gem/ruby/2.5.0/bin $PATH
set PATH $HOME/.yarn/bin $PATH
set PATH $HOME/app/flutter/bin $PATH

set --export ANDROID_HOME $HOME/Android/Sdk
set PATH $PATH $ANDROID_HOME/emulator
set PATH $PATH $ANDROID_HOME/tools
set PATH $PATH $ANDROID_HOME/tools/bin
set PATH $PATH $ANDROID_HOME/platform-tools

alias g="git"

function sync-history-peco-select-history
  sync-history
  peco_select_history $argv
end

function ghq-cd
  gqh look $argv
end

function fish_user_key_bindings
  bind \cr 'sync-history-peco-select-history (commandline -b)'
  bind \cf 'ghq_change_directory'
end

functions --copy cd standard_cd

function cd
  standard_cd $argv; and ls
end

# direnv
eval (direnv hook fish)
