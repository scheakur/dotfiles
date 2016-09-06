if !vimrc#plugin_exists('vim-gf-user')
	finish
endif

function! s:fname(name) abort
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction


function! s:jump_to_import_file() abort
	let path = s:extract_path()

	if empty(path)
		return 0
	endif

	let full_path = s:detect_full_path(path)

	if empty(full_path)
		return 0
	endif

	return {
	\	'path': full_path,
	\	'line': 0,
	\	'col': 0,
	\}
endfunction


function! s:extract_path() abort
	let quote = "\['\"\]"
	let current = line('.')
	let [sl, sc] = searchpos(quote, 'bn', current)
	let [el, ec] = searchpos(quote, 'n', current)

	if sl == 0 || el == 0
		return ''
	endif

	let line = getline('.')

	return line[sc:ec - 2]
endfunction


function! s:detect_full_path(path) abort
	let full_path = simplify(expand('%:h') . '/' . a:path)

	if filereadable(full_path)
		return full_path
	endif

	if isdirectory(full_path)
		return s:select_extension(full_path . '/index', ['.js', '.jsx'])
	endif

	return s:select_extension(full_path, ['.js', '.jsx'])
endfunction


function! s:select_extension(path, extensions) abort
	for ext in a:extensions
		if filereadable(a:path . ext)
			return a:path . ext
		endif
	endfor

	return ''
endfunction


if !exists('*s:override_gf')
	function! s:override_gf() abort
		let fn = s:fname('jump_to_import_file')
		if gf#user#try(fn, 'gf') is 0
			try 
				normal! gf
			catch /\C\V\^Vim\%((\a\+)\)\?:\(E446\|E447\):/
				echohl ErrorMsg
				echomsg substitute(v:exception, '\C^Vim.\{-}:', '', '')
				echohl NONE
			endtry
		endif
	endfunction
endif


nnoremap <buffer><silent> gf  :<C-u>call <SID>override_gf()<CR>
