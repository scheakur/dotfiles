setlocal foldmethod=syntax

function! s:make_folding_label() abort
	if getline(v:foldstart) !~# '^\s*<propert\(y\|ies\)\s\+name="[^"]\+"'
		return foldtext()
	endif
	let l:line = s:shorten(getline(v:foldstart) . s:get_sub_info(v:foldstart, v:foldend))
	return l:line
endfunction


function! s:get_sub_info(start, end)
	let re_list = map(['id', 'title'], "'^\\s*<propert\\(y\\|ies\\)\\s\\+name=\"' . v:val . '\"'")
	let range = range(min([6, a:end - a:start]))

	let matched = []

	for re in re_list
		for i in range
			let line = getline(a:start + i + 1)
			if line =~# re
				call add(matched, line)
				break
			endif
		endfor
	endfor

	if len(matched) > 0
		return join(matched, '')
	endif

	return getline(a:start + 1)
endfunction


function! s:shorten(line) abort
	let l:rv = substitute(a:line, '<propert\(y\|ies\)\s\+name="\([^"]\+\)"', '<\2', 'g')
	let l:rv = substitute(l:rv, '\s*value=', '=', 'g')
	let l:rv = substitute(l:rv, '\(<[a-zA-Z0-9\-]*\)>\s*<', '\1 ', 'g')
	let l:rv = substitute(l:rv, '/\?>\s*<', '', 'g')
	return l:rv
endfunction


function! s:fname(name) abort
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction


execute 'setlocal foldtext=' . s:fname('make_folding_label') . '()'
