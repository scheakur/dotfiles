if [ "$__DOT_PROFILE_IS_LOADED__" = "1" ]; then
    return
fi

export __DOT_PROFILE_IS_LOADED__=1


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
export GOROOT=$HOME/app/go
PATH=$GOROOT/bin:$PATH
export GOPATH=$HOME
PATH=$GOPATH/bin:$PATH

# local bin
PATH=$HOME/local/bin:$HOME/bin:$PATH

export PATH

# nvm
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" # This loads nvm

# rbenv
eval "$(rbenv init -)"

export __DOT_PROFILE_IS_LOADED__=1
