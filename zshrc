# vim: set foldmethod=marker :


# prompt {{{
local GREEN=$'%{\e[32m%}'
local DEFAULT=$'%{\e[m%}'

export PROMPT=$GREEN'%n@%m:%~
%(!.#.$) '$DEFAULT
export RPROMPT=''
# }}}


# complete {{{
autoload -U compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# }}}


# misc {{{
export TERM=xterm-256color
export EDITOR=vim
export LANG=ja_JP.UTF-8
bindkey -e
# }}}


# directory {{{
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

case "${OSTYPE}" in
darwin*)
        alias ls='ls -GFv'
        ;;
linux-gnu*)
        alias ls='ls --color -Fv'
        ;;
esac

alias ll='ls -l'
alias la='ls -al'
alias dir='ls'

zstyle ':completion:*' list-colors ''

function chpwd() {
    ls
}

function cdup() {
    echo
    cd ..
    zle reset-prompt
}
zle -N cdup
bindkey '\^' cdup
# }}}


# history {{{
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt append_history
setopt hist_ignore_dups
setopt share_history

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
# }}}


# util alias {{{
alias antd='date; ant deploy; date'
# }}}


# for root user {{{
case ${UID} in
0)
    # TBD
    ;;
esac
# }}}


# finally {{{
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
# }}}

