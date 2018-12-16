function _peco_change_directory
  if [ (count $argv) ]
    peco --query "$argv" | read foo
    commandline -- "cd $foo"
  else
    commandline ''
  end
end

function ghq_change_directory
  ghq list -p | _peco_change_directory $argv
end
