# ============================================================================ #
#                                    zshrc                                     #
# ============================================================================ #

# basic {{{
autoload -Uz add-zsh-hook

setopt extended_glob
setopt no_hup
setopt no_checkjobs

export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LOCALE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

bindkey -e

disable r

if [ "$TERM" != 'screen-256color' ]; then
    export TERM='xterm-256color'
fi

# edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

bindkey $terminfo[kRIT] forward-word
bindkey $terminfo[kLFT] backward-word

export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
# }}}


# OS dependent {{{
case "${OSTYPE}" in
    darwin*)
        alias ls='ls -GFv'
        alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
        ;;
    linux-gnu*)
        alias ls='ls --color -Fv'
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
        alias open='xdg-open'
        ;;
esac
# }}}


# prompt {{{
# Git settings
# http://d.hatena.ne.jp/uasi/20091017/1255712789
# http://gist.github.com/214109
autoload -Uz VCS_INFO_get_data_git && VCS_INFO_get_data_git 2> /dev/null

setopt prompt_subst

function zshrc-prompt-git-info { # {{{
    local branch st color gitdir action user stash
    if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
        return
    fi

    branch=$(basename "$(command git symbolic-ref HEAD 2> /dev/null)")
    if [[ -z $branch ]]; then
        return
    fi

    st=$(command git status 2> /dev/null)
    if [[ -n $(echo "$st" | grep '^nothing to') ]]; then
        color=green
    elif [[ -n $(echo "$st" | grep '^no changes added') ]]; then
        color=yellow
    elif [[ -n $(echo "$st" | grep '^Changes to be committed') ]]; then
        color=red
    else
        color=blue
    fi

    user=$(command git config --get user.name 2> /dev/null)
    gitdir=$(command git rev-parse --git-dir 2> /dev/null)
    action=$(VCS_INFO_git_getaction "$gitdir") && action="($action)"
    stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ') && stash="[$stash]"

    echo "%F{$color}$user$action@$branch$stash%f"
} # }}}

export PROMPT='%F{blue}[%D{%m/%d %H:%M}]%f %F{cyan}%n@%m:%~%f $(zshrc-prompt-git-info)
%F{cyan}%(!.#.$)%f '
export RPROMPT=''
# }}}


# complete {{{
autoload -Uz compinit && compinit

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose true
zstyle ':completion:*:processes' command "ps -u $USER -o pid,command"

fpath=(
    $HOME/src/github.com/zsh-users/zsh-completions
    /usr/local/share/zsh-completions
    $fpath
)
fpath=(${^fpath}(N-/^W))
# }}}


# directory {{{
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

alias ll='ls -l'
alias la='ls -al'
alias dir='ls'

function zshrc-chpwd() {
    ls
}
add-zsh-hook chpwd zshrc-chpwd

hash -d gh=$HOME/src/github.com/scheakur
hash -d bb=$HOME/src/bitbucket.org/scheakur
# }}}


# history {{{
export HISTFILE=~/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt append_history
setopt inc_append_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt share_history
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_no_functions
setopt interactive_comments

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward-end
bindkey '^N' history-beginning-search-forward-end
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
# }}}


# peco {{{
function zshrc-exists() {
    which $1 &> /dev/null
}

function zshrc-peco-ghq-cd() {
    local selected_dir=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

function zshrc-peco-mysnippets() {
    local f=~/.config/peco/mysnippets.sh
    BUFFER=$(cat $f | \grep -v '^#' | \grep -v '^$'| peco --query "$LBUFFER")
    zle clear-screen
}

if zshrc-exists peco; then
    if zshrc-exists ghq; then
        zle -N zshrc-peco-ghq-cd
        bindkey '^ ' zshrc-peco-ghq-cd
    fi

    zle -N zshrc-peco-mysnippets
    bindkey '^xs' zshrc-peco-mysnippets
fi
# }}}


# misc {{{
alias grep='grep -Ei --color=auto'
export GREP_COLORS='fn=01;34:mt=00;33'

autoload -Uz zmv
alias zmv='noglob zmv -W -n'
alias zmv!='noglob zmv -W'

# vim -(^z)-> terminal -(^z)-> vim
bindkey -s '^z' '^[q fg^m'

alias v=vim
alias g=git

function git() {
    if [[ $1 == "clone" ]]; then
        shift
        ghq get $@
    else
        command git $@
    fi
}

[[ -f $HOME/.config/tmuxinator/tmuxinator.zsh ]] && source $HOME/.config/tmuxinator/tmuxinator.zsh

alias hexdump='od -A x -t x1z -v'
# }}}


# finally {{{
stty -ixon
[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
# }}}

# vim: set foldmethod=marker :
# vim: set formatoptions& formatoptions-=ro :
