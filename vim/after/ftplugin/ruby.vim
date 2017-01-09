setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal iskeyword+==,?,!,@-@,$
setlocal dictionary=$HOME/.vim/dict/ruby.dict

inoremap <buffer><expr> \|  vimrc#input_pair_char_nicely('\|', [' { ', ' do '])

setlocal foldmethod=syntax

function! s:make_folding_label() abort
	let line = getline(v:foldstart)
	if (line =~# '/\*\*\?\s*')
		let next = getline(v:foldstart + 1)
		let next = substitute(next, '^\s*\*\?\s*', '', '')
		let line = substitute(line, '/\*\*\?\zs\s*', '', '')
		let line .= ' ' . next
	endif
	let line .= ' # ' . (v:foldend - v:foldstart + 1) . ' lines'
	return line
endfunction

function! s:fname(name)
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction

execute 'setlocal foldtext=' . s:fname('make_folding_label') . '()'
