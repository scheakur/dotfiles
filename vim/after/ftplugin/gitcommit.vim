function! s:complete_log(findstart, base)
	if a:findstart == 1
		return col('.')
	endif

	let cmd = '\git log --pretty=format:%s --author=`\git config user.name` -30'
	return split(system(cmd), '\n')
endfunction


function! s:fname(name)
	return vimrc#fname(a:name, expand('<sfile>'))
endfunction


execute 'setlocal omnifunc=' . s:fname('complete_log')

setlocal formatoptions-=t
setlocal colorcolumn=73
setlocal fileencoding=utf-8
