setlocal foldmethod=syntax
setlocal foldtext=MakeXMLFoldingLabelWithStartLineAndNumbersOfFoldedLines()

function! MakeXMLFoldingLabelWithStartLineAndNumbersOfFoldedLines()
    let l:line = getline(v:foldstart)
    let l:line .= ' // +' . (v:foldend - v:foldstart) . ' lines'
    return l:line
endfunction

