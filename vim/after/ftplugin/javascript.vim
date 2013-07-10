setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

" If vim-javascript is active, this config means nothing.
setlocal cinoptions=l1,:0,j1,J1

" format javascirpt by js-beautify (node.js)
command! -buffer FormatJavaScript  :%!js-beautify --jslint-happy true --indent-size 2 %
command! -buffer FormatJavaScript4  :%!js-beautify --jslint-happy true --indent-size 4 %

nmap <buffer> <C-j>  <Plug>(jsdocy-add-jsdoc)
inoremap <buffer> /<CR>  <C-r>=jsdocy#make_jsdoc(1)<CR><ESC>dd
