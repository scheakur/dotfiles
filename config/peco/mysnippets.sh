# My working home
cd ~/Work/src/github.com/scheakur #home

# Activate Firefox Add-on SDK
cd ~/app/addon-sdk-1.17/; source bin/activate; cd - #addon

# Copy revision
svn info | grep -E '^Revision: ' | sed 's/Revision: /r/' | xsel -ib #copyrevision
git svn info | grep -E '^Revision: ' | sed 's/Revision: /r/' | xsel -ib #copyrevision

# svn ignore
svn propset --recursive svn:ignore *.zip ./src

## sshfs
sshfs user@hostname: ~/mnt #sshfs
fusermount -u ~/mnt #sshfs

## git
git clean -d -f --dry-run # remove untracked files and dirs (dry run)
git remote -v # show remote settings

## ssh
ssh-keygen -t rsa -C "you@example.com"

## ps with first 100 chars
ps aux | grep PAT | cut -c -100
ps aux | grep PAT | sed -e 's/\(^.\{100\}\).*/\1/'


## byteman
$BYTEMAN_HOME/bin/bminstall.sh $(jps | grep Bootstrap | cut -d ' ' -f 1) # need $BYTEMAN_HOME


## etc
sudo tcpdump ip proto \\icmp  ## log ping request


## split path
echo $PATH | tr -s ':' '\n'


## netstat
netstat -tnpa
netstat -tnpl
lsof -nP -iTCP
lsof -nP -iTCP -sTCP:LISTEN


## nkf
find . -name "*.csv" | xargs nkf -w --overwrite
nkf --guess *.csv


screencapture -R100,100,800,600 ~/Desktop/1.png
