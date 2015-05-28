setlocal foldmethod=syntax

function! s:make_folding_label()
	if getline(v:foldstart) !~# '^\s*<propert\(y\|ies\)\s\+name="[^"]\+"'
		return foldtext()
	endif
	let l:line = s:shorten(getline(v:foldstart) . getline(v:foldstart + 1))
	return l:line
endfunction

function! s:shorten(line)
	let l:rv = substitute(a:line, '<propert\(y\|ies\)\s\+name="\([^"]\+\)"', '<\2', 'g')
	let l:rv = substitute(l:rv, '\s*value=', '=', 'g')
	let l:rv = substitute(l:rv, '\(<[a-zA-Z0-9\-]*\)>\s*<', '\1 ', 'g')
	return l:rv
endfunction

function! s:fname(name)
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction

execute 'setlocal foldtext=' . s:fname('make_folding_label') . '()'
