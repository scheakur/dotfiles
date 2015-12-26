setlocal foldmethod=syntax

function! s:make_folding_label() abort
	if getline(v:foldstart) !~# '^\s*<propert\(y\|ies\)\s\+name="[^"]\+"'
		return foldtext()
	endif
	let l:line = s:shorten(getline(v:foldstart) . s:get_sub_info(v:foldstart))
	return l:line
endfunction


function! s:get_sub_info(start)
	let re_list = map(['id', 'title'], "'^\\s*<propert\\(y\\|ies\\)\\s\\+name=\"' . v:val . '\"'")

	let matched = []

	for i in range(3)
		let line = getline(a:start + i + 1)
		for re in re_list
			if line =~# re
				call add(matched, line)
			endif
		endfor
	endfor

	if len(matched) > 0
		return join(matched, '')
	endif

	return getline(a:start + 1)
endfunction

function! s:id(start) abort
	return s:getline(a:start, 'id')
endfunction


function! s:title(start) abort
	return s:getline(a:start, 'title')
endfunction


function! s:getline(start, name) abort
	let re = '^\s*<propert\(y\|ies\)\s\+name="' . a:name . '"'

	for i in range(3)
		let line = getline(a:start + i + 1)
		if line =~# re
			return line
		endif
	endfor

	return ''
endfunction


function! s:shorten(line) abort
	let l:rv = substitute(a:line, '<propert\(y\|ies\)\s\+name="\([^"]\+\)"', '<\2', 'g')
	let l:rv = substitute(l:rv, '\s*value=', '=', 'g')
	let l:rv = substitute(l:rv, '\(<[a-zA-Z0-9\-]*\)>\s*<', '\1 ', 'g')
	let l:rv = substitute(l:rv, '/>\s*<', '', 'g')
	return l:rv
endfunction

function! s:fname(name) abort
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction

execute 'setlocal foldtext=' . s:fname('make_folding_label') . '()'
