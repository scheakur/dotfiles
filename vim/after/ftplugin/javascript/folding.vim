setlocal foldmethod=syntax

function! s:make_folding_label()
	let line = getline(v:foldstart)
	if (line =~# '/\*\*\?\s*')
		let next = getline(v:foldstart + 1)
		let next = substitute(next, '^\s*\*\?\s*', '', '')
		let line = substitute(line, '/\*\*\?\zs\s*', '', '')
		let line .= ' ' . next
	endif
	let line .= ' // ' . (v:foldend - v:foldstart + 1) . ' lines'
	return line
endfunction

function! s:fname(name)
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction

execute 'setlocal foldtext=' . s:fname('make_folding_label') . '()'
