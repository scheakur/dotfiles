setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal foldmethod=syntax
setlocal foldtext=MakeXMLFoldingLabelByConcatenatingNextLine()

inoremap <buffer> <LT>/  <LT>/<C-x><C-o>
inoremap <buffer> <LT>?  <LT>/<C-x><C-o>
inoremap <buffer> ?>  />

function! MakeXMLFoldingLabelByConcatenatingNextLine()
    if getline(v:foldstart) !~# '^\s*<propert\(y\|ies\)\s\+name="[^"]\+"'
      return foldtext()
    endif
    let l:line = s:shorten(getline(v:foldstart) . getline(v:foldstart + 1))
    return l:line
endfunction

function! s:shorten(line)
    let l:rv = substitute(a:line, '<propert\(y\|ies\)\s\+name="\([^"]\+\)"', '<\2', 'g')
    let l:rv = substitute(l:rv, '\s*value=', '=', 'g')
    let l:rv = substitute(l:rv, '\(<[a-zA-Z0-9\-]*\)>\s*<', '\1 ', 'g')
    return l:rv
endfunction

