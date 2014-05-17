# vim: set foldmethod=marker :


# prompt {{{
# Git settings
# http://d.hatena.ne.jp/uasi/20091017/1255712789
# http://gist.github.com/214109
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

setopt prompt_subst

function rprompt-git-current-branch {
    local name st color gitdir action user
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
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        color=%F{green}
    elif [[ -n `echo "$st" | grep "^no changes added"` ]]; then
        color=%F{yellow}
    elif [[ -n `echo "$st" | grep "^# Changes to be committed"` ]]; then
        color=%B%F{red}
    else
        color=%F{red}
    fi

    user=`git config --get user.name 2> /dev/null` && user="@$user"

    echo "$color$name$action$user%f%b "
}

local COLOR='%F{cyan}'
local DEFAULT='%F{default}'
export PROMPT='%F{blue}[%D{%m/%d %H:%M}]$COLOR %n@%m:%~ `rprompt-git-current-branch`
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


export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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

# util {{{
autoload -Uz zmv
alias zmv='noglob zmv -W'
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


# job {{{
setopt no_hup
setopt no_checkjobs
# }}}

# for root user {{{
case ${UID} in
0)
    # TBD
    ;;
esac
# }}}

# development {{{
alias v=vim
alias g=git
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

stty -ixon

# finally {{{
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
# }}}

