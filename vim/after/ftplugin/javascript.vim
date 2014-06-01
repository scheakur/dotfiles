setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal comments-=://
setlocal comments+=f://

" If vim-javascript is active, this config means nothing.
setlocal cinoptions=l1,:0,j1,J1

" format javascirpt by js-beautify (node.js)
function! s:fname(name)
	let sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_fname$')
	return printf('<SNR>%s_%s', sid, a:name)
endfunction

function! s:jsbeautify(indent_size)
	execute 'silent! %!js-beautify -f - --jslint-happy true --indent-size' a:indent_size
endfunction

execute 'command! -buffer FormatJavaScript  :call' s:fname('jsbeautify') '(2)'
execute 'command! -buffer FormatJavaScript4  :call' s:fname('jsbeautify') '(4)'

nmap <buffer> <C-j>  <Plug>(jsdocy-add-jsdoc)
inoremap <buffer> /<CR>  <C-r>=jsdocy#make_jsdoc(1)<CR><ESC>dd
