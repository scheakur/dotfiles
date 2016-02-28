function! s:list_syntax(start, cycle) abort
	let indent = 2
	return printf('"\v^\s{%s}(\s{%s})*\zs[-+*]\ze\s+"', indent * a:start, indent * a:cycle)
endfunction

function! s:set_syntax() abort
	let marks = (has('mac') || has('macunix')) ? ['▪', '▸', '∙', '▹', '￮', '⋆'] : ['￭', '▸', '∙', '▹', '￮', '⋆']
	let n = len(marks)
	for i in range(n)
		execute 'syntax match tracListItem' . i s:list_syntax(i, n) 'conceal cchar=' . marks[i]
		execute 'highlight link tracListItem' . i 'Identifier'
	endfor
endfunction

highlight clear Conceal
highlight link Conceal Identifier

syntax clear tracListItem

call s:set_syntax()
