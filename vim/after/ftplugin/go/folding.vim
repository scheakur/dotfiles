setlocal foldmethod=syntax
setlocal foldminlines=5
setlocal foldtext=MakeGoFoldingLabelWithStartLineAndNumbersOfFoldedLines()

function! MakeGoFoldingLabelWithStartLineAndNumbersOfFoldedLines()
	let line = getline(v:foldstart)
	if (line =~# '/\*\*\?\s*')
		let next = getline(v:foldstart + 1)
		let next = substitute(next, '^\s*\*\?\s*', '', '')
		let line = substitute(line, '/\*\*\?\zs\s*', '', '')
		let line .= ' ' . next
	endif
	let sp = repeat(' ', &tabstop)
	let line = substitute(line, '\t', sp, 'g')
	let line .= ' // ' . (v:foldend - v:foldstart + 1) . ' lines'
	return line
endfunction
