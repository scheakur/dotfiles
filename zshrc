# vim: set foldmethod=marker :


# prompt {{{
# Git settings
# http://d.hatena.ne.jp/uasi/20091017/1255712789
# http://gist.github.com/214109
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

setopt prompt_subst
setopt re_match_pcre

function rprompt-git-current-branch {
    local name st color gitdir action
    if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
        return
    fi
    name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
    if [[ -z $name ]]; then
        return
    fi

    gitdir=`git rev-parse --git-dir 2> /dev/null`
    action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

    st=`git status 2> /dev/null`
    if [[ "$st" =~ "(?m)^nothing to" ]]; then
        color=%F{green}
    elif [[ "$st" =~ "(?m)^nothing added" ]]; then
        color=%F{yellow}
    elif [[ "$st" =~ "(?m)^# Untracked" ]]; then
        color=%B%F{red}
    else
        color=%F{red}
    fi

    echo "$color$name$action%f%b "
}

local COLOR='%F{cyan}'
local DEFAULT='%F{white}'
export PROMPT=$COLOR'%n@%m:%~ `rprompt-git-current-branch`
%(!.#.$) '$DEFAULT
export RPROMPT=''
# }}}


# complete {{{
autoload -U compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# }}}


# misc {{{
if [ "$TERM" != "screen-256color" ]; then
    export TERM="xterm-256color"
fi
export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LOCALE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
bindkey -e

# export GREP_OPTIONS='-Ein --color=auto'
export GREP_COLORS='fn=01;34:mt=00;33'
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
# bindkey '\^' cdup
# }}}


# history {{{
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt append_history
setopt hist_ignore_dups
setopt share_history
setopt interactive_comments

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
# }}}


# for root user {{{
case ${UID} in
0)
    # TBD
    ;;
esac
# }}}

# OS dependent
case "${OSTYPE}" in
darwin*)
        alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
        ;;
linux-gnu*)
        alias pbcopy='xsel --clipboard --input'
        ;;
esac


# finally {{{
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
# }}}

