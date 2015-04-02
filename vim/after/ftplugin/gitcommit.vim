function! s:complete_log(findstart, base)
	if a:findstart == 1
		return col('.')
	endif

	let cmd = '\git log --pretty=format:%s --author=`\git config user.name` -30'
	return split(system(cmd), '\n')
endfunction


function! s:fname(name)
	let sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_fname$')
	return printf('<SNR>%s_%s', sid, a:name)
endfunction


execute 'setlocal omnifunc=' . s:fname('complete_log')

setlocal formatoptions-=t
setlocal colorcolumn=73
setlocal fileencoding=utf-8
