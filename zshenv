source $HOME/.profile

# remove duplicate path
typeset -U path cdpath fpath manpath

# remove nil directory
path=(${^path}(N-/^W))
