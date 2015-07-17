# remove duplicate path
typeset -U path cdpath fpath manpath

path=(
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    /usr/sbin
    /sbin
    $path
)

export JAVA_HOME=$HOME/app/java
path=($JAVA_HOME/bin $path)

export MAVEN_HOME=$HOME/app/maven
path=($MAVEN_HOME/bin $path)

export ANT_HOME=$HOME/app/ant
path=($ANT_HOME/bin $path)

export IVY_HOME=$HOME/app/ivy
path=($IVY_HOME/bin $path)

export FINDBUGS_HOME=$HOME/app/findbugs
path=($FINDBUGS_HOME/bin $path)

export GRADLE_HOME=$HOME/app/gradle
path=($GRADLE_HOME/bin $path)

export SCALA_HOME=$HOME/app/scala
path=($SCALA_HOME/bin $path)

export PLAY_HOME=$HOME/app/play
path=($PLAY_HOME/bin $path)

export ELIXIR_HOME=$HOME/app/elixir
path=($ELIXIR_HOME/bin $path)

# oracle
export NLS_LANG=English_Japan.AL32UTF8

# golang
if [ -s "$HOME/app/go" ]; then
    export GOROOT=$HOME/app/go
else
    export GOROOT=/usr/local/go
fi
export GOPATH=$HOME
path=($GOPATH/bin $GOROOT/bin $path)

# nodebrew
path=($HOME/.nodebrew/current/bin $path)

# heroku toolbelt
path=(/usr/local/heroku/bin  $path)

# nvm
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" # This loads nvm

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# rbenv
path=($HOME/.rbenv/bin $path)
eval "$(rbenv init -)"

path=($HOME/local/bin $HOME/bin $path)

# remove nil directory
path=(${^path}(N-/^W))

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "$HOME/.gvm/bin/gvm-init.sh" ]] && source "$HOME/.gvm/bin/gvm-init.sh"
