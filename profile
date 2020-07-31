# ============================================================================ #
#                                   profile                                    #
# ============================================================================ #

PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin

export MY_HOME=$HOME

export JAVA_HOME=$MY_HOME/app/java
PATH=$JAVA_HOME/bin:$PATH

export MAVEN_HOME=$MY_HOME/app/maven
PATH=$MAVEN_HOME/bin:$PATH

export ANT_HOME=$MY_HOME/app/ant
PATH=$ANT_HOME/bin:$PATH

export IVY_HOME=$MY_HOME/app/ivy
PATH=$IVY_HOME/bin:$PATH

export FINDBUGS_HOME=$MY_HOME/app/findbugs
PATH=$FINDBUGS_HOME/bin:$PATH

export GRADLE_HOME=$MY_HOME/app/gradle
PATH=$GRADLE_HOME/bin:$PATH

export SCALA_HOME=$MY_HOME/app/scala
PATH=$SCALA_HOME/bin:$PATH

export PLAY_HOME=$MY_HOME/app/play
PATH=$PLAY_HOME/bin:$PATH

export ELIXIR_HOME=$MY_HOME/app/elixir
PATH=$ELIXIR_HOME/bin:$PATH

# oracle
export NLS_LANG=English_Japan.AL32UTF8
export ORACLE_HOME=$MY_HOME/app/oracle
export DYLD_LIBRARY_PATH=$MY_HOME/app/oracle:$DYLD_LIBRARY_PATH
PATH=$MY_HOME/app/oracle:$PATH

# golang
export GOPATH=$MY_HOME
PATH=$GOPATH/bin:$PATH

# haskell
export PATH=$HOME/Library/Haskell/bin:$PATH

# android (Mac)
export ANDROID_HOME=$HOME/Library/Android/sdk
PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH

export ANDROID_NDK=$HOME/Library/Android/ndk

# heroku toolbelt
PATH=/usr/local/heroku/bin:$PATH

# nodebrew
PATH=$HOME/.nodebrew/current/bin:$PATH

# nvm
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" # This loads nvm

# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

# rbenv
PATH=$HOME/.rbenv/bin:$PATH
if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

PATH=$HOME/.local/bin:$HOME/local/bin:$HOME/bin:$PATH

export PATH

# pythonz
[[ -s $HOME/.pythonz/etc/bashrc ]] && source $HOME/.pythonz/etc/bashrc

# sdkman
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# yarn
export PATH="$PATH:`yarn global bin`"

# homebrew python
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# load environment specific .profile
[[ -s "$HOME/.profile.local" ]] && source "$HOME/.profile.local"

# vim: ft=sh
