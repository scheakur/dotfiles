function git --description 'Git with ghq'
	if test $argv[1] = "clone"
		set --erase argv[1]
		ghq get $argv
	else
		command git $argv
	end
end
