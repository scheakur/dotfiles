setlocal iskeyword-=#

setlocal noexpandtab

setlocal foldtext=MakeVimFoldingLabelWithStartLineAndNumbersOfFoldedLines()
function! MakeVimFoldingLabelWithStartLineAndNumbersOfFoldedLines()
    let line = getline(v:foldstart)
    let line .= ' " +' . (v:foldend - v:foldstart) . ' lines'
    return line
endfunction
