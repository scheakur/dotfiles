# vim: set foldmethod=marker :


# prompt {{{
local GREEN=$'%{\e[32m%}'
local DEFAULT=$'%{\e[m%}'

export PROMPT=$GREEN'%n@%m:%~
%(!.#.$) '$DEFAULT
export RPROMPT=''
# }}}


# env {{{
export TERM=xterm-256color
export EDITOR=vim
# }}}


# history {{{
HISTFILE=~/.zsh_history
HISTSIZE=999999
SAVEHIST=999999
# }}}


# alias {{{
alias ls='ls -GFv --color'
alias ll='ls -GFl'
alias la='ls -GFal'
# }}}


# function {{{
function chpwd() {
    ls -GFv --color
}
# }}}

