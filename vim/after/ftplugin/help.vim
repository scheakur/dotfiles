nnoremap <buffer> q <C-w>c


function! s:jumpable()
	return synIDattr(synID(line('.'), col('.'), 1), 'name') == 'helpHyperTextJump'
endfunction

nnoremap  <buffer><expr> <CR>  <SID>jumpable() ? "\<C-]>" : "<CR>"

nnoremap <buffer> <S-CR>  <C-t>
