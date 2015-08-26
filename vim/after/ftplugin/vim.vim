setlocal iskeyword-=#
setlocal noexpandtab
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal dictionary=$HOME/.vim/dict/vim.dict

function! s:make_folding_label() abort
	let line = getline(v:foldstart)
	let line .= ' " ' . (v:foldend - v:foldstart + 1) . ' lines'
	return line
endfunction

function! s:fname(name)
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction

execute 'setlocal foldtext=' . s:fname('make_folding_label') . '()'
