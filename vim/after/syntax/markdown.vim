function! s:list_syntax(start, cycle) abort
	let indent = 4
	return printf('"\v^\s{%s}(\s{%s})*\zs[-+*]\ze\s+"', indent * a:start, indent * a:cycle)
endfunction


function! s:set_syntax() abort
	let marks = (has('mac') || has('macunix')) ? ['∙', '▸', '￮', '▹', '⋆', '▪'] : ['￭', '▸', '∙', '▹', '￮', '⋆']
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

highlight link htmlH1 Statement
highlight link htmlH2 Function
highlight link htmlH3 Number
highlight link htmlH4 Type
highlight link htmlH5 Operator
highlight link htmlH6 Special
