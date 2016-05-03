setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal comments-=://
setlocal comments+=f://
setlocal iskeyword+=@-@
setlocal dictionary=$HOME/.vim/dict/javascript.dict

" If vim-javascript is active, this config means nothing.
setlocal cinoptions=l1,:0,j1,J1
setlocal cinkeys=0{,0},0),:,!^F,o,O,e,0]

" format javascirpt by js-beautify (node.js)
function! s:jsbeautify(indent_size)
	execute 'silent! %!js-beautify -f - --indent-size' a:indent_size
endfunction

command! -buffer FormatJavaScript  call <SID>jsbeautify(2)
command! -buffer FormatJavaScript4  call <SID>jsbeautify(4)

nmap <buffer> <C-j>  <Plug>(jsdocy-add-jsdoc)
inoremap <buffer> /<CR>  <C-r>=jsdocy#make_jsdoc(1)<CR><ESC>dd

if exists('g:xml_syntax_folding')
	let s:xml_syntax_folding = g:xml_syntax_folding
	unlet g:xml_syntax_folding

	augroup vimrc_javascript
		autocmd!
		autocmd BufLeave,WinLeave *.js   let g:xml_syntax_folding = s:xml_syntax_folding
		autocmd BufLeave,WinLeave *.jsx  let g:xml_syntax_folding = s:xml_syntax_folding
	augroup end
endif
