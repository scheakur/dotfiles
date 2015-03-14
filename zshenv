# remove duplicate path
typeset -U path PATH

export JAVA_HOME=$HOME/app/java
export MAVEN_HOME=$HOME/app/maven
export ANT_HOME=$HOME/app/ant
export IVY_HOME=$HOME/app/ivy
export FINDBUGS_HOME=$HOME/app/findbugs
export GRADLE_HOME=$HOME/app/gradle
export SCALA_HOME=$HOME/app/scala
export PLAY_HOME=$HOME/app/play
export ELIXIR_HOME=$HOME/app/elixir

# oracle
export NLS_LANG=English_Japan.AL32UTF8

# golang
if [ -s "$HOME/app/go" ]; then
    export GOROOT=$HOME/app/go
else
    export GOROOT=/usr/local/go
fi
export GOPATH=$HOME


path=(
    $HOME/local/bin
    $HOME/bin
    $JAVA_HOME/bin
    $MAVEN_HOME/bin
    $ANT_HOME/bin
    $IVY_HOME/bin
    $FINDBUGS_HOME/bin
    $GRADLE_HOME/bin
    $SCALA_HOME/bin
    $PLAY_HOME/bin
    $ELIXIR_HOME/bin
    $GOPATH/bin
    $GOROOT/bin
    $HOME/.nodebrew/current/bin
    /usr/local/heroku/bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/local/sbin
    /usr/sbin
    /sbin
    $path
)

# nvm
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" # This loads nvm

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# rbenv
eval "$(rbenv init -)"

path=(${^path}(N-/^W))

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "$HOME/.gvm/bin/gvm-init.sh" ]] && source "$HOME/.gvm/bin/gvm-init.sh"
