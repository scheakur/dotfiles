function! s:list_syntax(start, cycle) abort
	let indent = 2
	return printf('"\v^\s{%s}(\s{%s})*\zs[-+*]\ze\s+"', indent * a:start, indent * a:cycle)
endfunction


function! s:set_syntax() abort
	let marks = s:select_marks()
	let n = len(marks)
	for i in range(n)
		execute 'syntax match markdownListItem' . i s:list_syntax(i, n) 'conceal cchar=' . marks[i]
		execute 'highlight link markdownListItem' . i 'Identifier'
	endfor
endfunction


function! s:select_marks() abort
	if has('mac') || has('macunix')
		return ['∙', '▸', '￮', '▹', '⋆', '▪']
	endif

	if has('win')
		return ['￭', '▸', '∙', '▹', '￮', '⋆']
	endif

	return ['∙', '▸', '⋆', '▹', '◉', '-']
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
