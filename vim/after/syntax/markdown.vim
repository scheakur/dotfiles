setlocal conceallevel=2
setlocal concealcursor=ni

function! s:list_syntax(start, cycle)
	return printf('"\v^\s{%s}(\s{%s})*\zs[-+*]\ze\s+"', &shiftwidth * a:start, &shiftwidth * a:cycle)
endfunction

execute 'syntax match markdownListItem1' s:list_syntax(0, 3) 'conceal cchar=￭'
execute 'syntax match markdownListItem2' s:list_syntax(1, 3) 'conceal cchar=￮'
execute 'syntax match markdownListItem3' s:list_syntax(2, 3) 'conceal cchar=∙'

syntax clear mkdListItem
syntax match markdownOrderedListItem '^\s*\zs\d\+\.\ze\s\+'

highlight clear Conceal
highlight link Conceal Identifier
highlight link markdownListItem1 Identifier
highlight link markdownListItem2 Identifier
highlight link markdownListItem3 Identifier
highlight link markdownOrderedListItem Identifier
