setlocal conceallevel=2
setlocal concealcursor=ni

function! s:list_syntax(start, cycle)
	return printf('"\v^\s{%s}(\s{%s})*\zs[-+*]\ze\s+"', &shiftwidth * a:start, &shiftwidth * a:cycle)
endfunction

function! s:set_syntax()
	let marks = ['￭', '►', '∙', '⎕', '⊳', '￮', '⋆']
	let n = len(marks)
	for i in range(n)
		execute 'syntax match markdownListItem' . i s:list_syntax(i, n) 'conceal cchar=' . marks[i]
		execute 'highlight link markdownListItem' . i 'Identifier'
	endfor
endfunction

highlight clear Conceal
highlight link Conceal Identifier

syntax clear mkdListItem

call s:set_syntax()

syntax match markdownOrderedListItem '^\s*\zs\d\+\.\ze\s\+'
highlight link markdownOrderedListItem Identifier
