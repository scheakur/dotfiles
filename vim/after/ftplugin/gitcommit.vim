function! s:complete_log(findstart, base)
	if a:findstart == 1
		return col('.')
	endif

	let logs = split(system('git log --oneline --author=`git config user.name` -30 | cut -d " " -f 2-'), '\n')
	return logs
endfunction


function! s:fname(name)
	let sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_fname$')
	return printf('<SNR>%s_%s', sid, a:name)
endfunction


execute 'setlocal omnifunc=' . s:fname('complete_log')
