nnoremap <buffer> q <C-w>c


function! s:jumpable()
	return synIDattr(synID(line('.'), col('.'), 1), 'name') == 'helpHyperTextJump'
endfunction

function! s:fname(name)
	let sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_fname$')
	return printf('<SNR>%s_%s', sid, a:name)
endfunction

execute 'nnoremap  <buffer><expr> <CR>  ' . s:fname('jumpable') . '() ? "\<C-]>" : "<CR>"'

nnoremap <buffer> <S-CR>  <C-t>
