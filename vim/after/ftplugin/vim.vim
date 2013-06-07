setlocal iskeyword-=#

setlocal noexpandtab

setlocal foldtext=MakeVimFoldingLabelWithStartLineAndNumbersOfFoldedLines()
function! MakeVimFoldingLabelWithStartLineAndNumbersOfFoldedLines()
    let line = getline(v:foldstart)
    let line .= ' " ' . (v:foldend - v:foldstart + 1) . ' lines'
    return line
endfunction
