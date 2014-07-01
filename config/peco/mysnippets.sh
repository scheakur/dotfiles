# Open 1Password
chromium-browser --temp-profile --allow-file-access-from-files --incognito ~/Dropbox/etc/1Password.agilekeychain/1Password.html #1password

# Activate Firefox Add-on SDK
cd ~/app/addon-sdk-1.16/; source bin/activate; cd - #addon

# Copy revision
svn info | grep -E '^Revision: ' | sed 's/Revision: /r/' | xsel -ib #copyrevision
git svn info | grep -E '^Revision: ' | sed 's/Revision: /r/' | xsel -ib #copyrevision

## sshfs
sshfs user@hostname: ~/mnt
fusermount -u ~/mnt

