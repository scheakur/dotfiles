function git_ignore_symlink --description 'Add symlinks to .gitignore'
  find . -type l | sed -e s'/^\.\///g' >> .gitignore
end
