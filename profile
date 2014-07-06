if [ "$__DOT_PROFILE_IS_LOADED__" = "yes" ]; then
    return
fi

export __DOT_PROFILE_IS_LOADED__=yes

PATH=/sbin:$PATH
PATH=/usr/sbin:$PATH
PATH=/usr/local/sbin:$PATH

PATH=/usr/local/bin:$PATH

# java
export JAVA_HOME=$HOME/app/java
PATH=$JAVA_HOME/bin:$PATH

# maven
export MAVEN_HOME=$HOME/app/maven
PATH=$MAVEN_HOME/bin:$PATH

# ant
export ANT_HOME=$HOME/app/ant
PATH=$ANT_HOME/bin:$PATH

# ivy
export IVY_HOME=$HOME/app/ivy
PATH=$IVY_HOME/bin:$PATH

# findbugs
export FINDBUGS_HOME=$HOME/app/findbugs
PATH=$FINDBUGS_HOME/bin:$PATH

# gradle
export GRADLE_HOME=$HOME/app/gradle
PATH=$GRADLE_HOME/bin:$PATH

# scala
export SCALA_HOME=$HOME/app/scala
PATH=$SCALA_HOME/bin:$PATH

# play
export PLAY_HOME=$HOME/app/play
PATH=$PLAY_HOME/bin:$PATH

# elixir
export ELIXIR_HOME=$HOME/app/elixir
PATH=$ELIXIR_HOME/bin:$PATH

# oracle
export NLS_LANG=English_Japan.AL32UTF8

# golang
if [ -s "$HOME/app/go" ]; then
    export GOROOT=$HOME/app/go
else
    export GOROOT=/usr/local/go
fi
PATH=$GOROOT/bin:$PATH
export GOPATH=$HOME
PATH=$GOPATH/bin:$PATH

# local bin
PATH=$HOME/local/bin:$HOME/bin:$PATH

export PATH

# nvm
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" # This loads nvm

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# rbenv
eval "$(rbenv init -)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
