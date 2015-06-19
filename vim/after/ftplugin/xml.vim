setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

inoremap <buffer> <LT>/  <LT>/<C-x><C-o>
inoremap <buffer> <LT>?  <LT>/<C-x><C-o>
inoremap <buffer> ?>  />
inoremap <buffer> <Leader>c  <LT>![CDATA[<Enter>]]>
command! -buffer Cdata  call feedkeys("i<![CDATA[\<CR>]]>\<Up>")
