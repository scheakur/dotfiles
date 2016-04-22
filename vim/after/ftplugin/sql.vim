setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal dictionary=$HOME/.vim/dict/sql.dict

" format SQL {{{
let s:sql_keywords = [
\	'union all',
\	'minus',
\	'insert',
\	'delete',
\	'update',
\	'select',
\	'from',
\	'where',
\	'and',
\	'or',
\	'order by',
\	'group by',
\	'having',
\	'inner join',
\	'left outer join',
\	'right outer join',
\	'join',
\	'on',
\	'case',
\	'when',
\	'then',
\	'end',
\	'pivot',
\	'unpivot',
\	'for',
\	'start with',
\	'connect by nocycle',
\	'connect by',
\]

function! s:list2regex(list) " {{{
	let regexp = '\V\<\('
	let sep = ''
	for word in a:list
		let escaped = substitute(word, '\ ', '\\ ', '')
		let regexp .= sep . escaped
		let sep = '\|'
	endfor
	let regexp .= '\)\>'
	return regexp
endfunction " }}}

command! -buffer -range=% FormatSql
\	setlocal nohlsearch
\	| execute '<line1>,<line2>s!' . <SID>list2regex(s:sql_keywords) . '!\r&!g'
\	| g/\<select\>/s!, !,\r!g
\	| normal =ip
" }}}


