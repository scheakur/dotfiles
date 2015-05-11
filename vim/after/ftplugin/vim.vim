setlocal iskeyword-=#
setlocal noexpandtab
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal dictionary=$HOME/.vim/dict/vim.dict

setlocal foldtext=MakeVimFoldingLabelWithStartLineAndNumbersOfFoldedLines()
function! MakeVimFoldingLabelWithStartLineAndNumbersOfFoldedLines()
    let line = getline(v:foldstart)
    let line .= ' " ' . (v:foldend - v:foldstart + 1) . ' lines'
    return line
endfunction
