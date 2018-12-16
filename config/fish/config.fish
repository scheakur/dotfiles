set --export GOPATH $HOME
set PATH $GOPATH/bin $PATH
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.gem/ruby/2.5.0/bin $PATH
set PATH $HOME/.yarn/bin $PATH

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

# direnv
eval (direnv hook fish)
