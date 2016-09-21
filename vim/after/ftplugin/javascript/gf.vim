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
	if a:path =~# '^\.'
		let full_path = simplify(expand('%:h') . '/' . a:path)
		return s:complete_path(full_path)
	endif

	let base_dir = s:detect_base_dir(a:path)

	if a:path =~# '/'
		let full_path = simplify(base_dir . a:path)
		return s:complete_path(full_path)
	endif

	let json = join(readfile(base_dir . a:path . '/package.json'), '')
	let package_info = json_decode(json)
	let main = get(package_info, 'main', 'index.js')
	let full_path = simplify(base_dir . a:path . '/' . main)
	return s:complete_path(full_path)
endfunction


function! s:detect_project_root_dir() abort
	let dir = expand('%:p:h')

	while dir != '/'
		let path = dir . '/package.json'

		if isdirectory(path) || filereadable(path)
			return dir
		endif

		let dir = fnamemodify(dir, ':h')
	endwhile

	return ''
endfunction


function! s:detect_base_dir(path) abort
	let root_dir = s:detect_project_root_dir()

 	if root_dir =~# '/node_modules/'
		return substitute(root_dir,  '/node_modules/\zs.*', '', '')
	endif

	return root_dir . '/node_modules/'
endfunction


function! s:complete_path(path) abort
	if filereadable(a:path)
		return a:path
	endif

	if isdirectory(a:path)
		return s:select_suffix(a:path, ['/index.js', '/index.jsx'])
	endif

	" support react-native
	return s:select_suffix(a:path, ['.js', '.jsx', '.ios.js', '.android.js'])
endfunction


function! s:select_suffix(path, suffix_list) abort
	for suffix in a:suffix_list
		if filereadable(a:path . suffix)
			return a:path . suffix
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
