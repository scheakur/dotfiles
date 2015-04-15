setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal comments-=://
setlocal comments+=f://
setlocal dictionary=$HOME/.vim/dict/javascript.dict

" If vim-javascript is active, this config means nothing.
setlocal cinoptions=l1,:0,j1,J1

" format javascirpt by js-beautify (node.js)
function! s:jsbeautify(indent_size)
	execute 'silent! %!js-beautify -f - --indent-size' a:indent_size
endfunction

command! -buffer FormatJavaScript  call <SID>jsbeautify(2)
command! -buffer FormatJavaScript4  call <SID>jsbeautify(4)

nmap <buffer> <C-j>  <Plug>(jsdocy-add-jsdoc)
inoremap <buffer> /<CR>  <C-r>=jsdocy#make_jsdoc(1)<CR><ESC>dd
