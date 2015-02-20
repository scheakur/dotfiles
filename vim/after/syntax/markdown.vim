setlocal conceallevel=2
setlocal concealcursor=ni
syntax clear mkdListItem
syntax match markdownListItem1 '^\s*\zs-\ze\s\+'  conceal cchar=∙
syntax match markdownListItem2 '^\s*\zs+\ze\s\+'  conceal cchar=￮
syntax match markdownListItem3 '^\s*\zs\*\ze\s\+' conceal cchar=￭
syntax match markdownListItem4 '^\s*\zs\d\+\.\ze\s\+'
highlight clear Conceal
highlight link Conceal Identifier
highlight link markdownListItem1 Identifier
highlight link markdownListItem2 Identifier
highlight link markdownListItem3 Identifier
highlight link markdownListItem4 Identifier
