" ============================================================================ "
"                             functions for vimrc                              "
" ============================================================================ "

if exists('vimrc#loading') && vimrc#loading
	finish
endif

let vimrc#loading = 1


" handle environment-specific vimrc {{{
let s:error = []

function! vimrc#load_local_vimrc(...)
	let suffix = (a:0 > 0) ? ('.' . a:1) : ''
	let vimrc = expand('~/.vimrc.local' . suffix)
	if filereadable(vimrc)
		try
			execute 'source' vimrc
		catch
			call s:err('an error occurred in ' . vimrc)
			call s:err(v:exception) " This might be slow
		endtry
	endif
endfunction


function! s:err(msg)
	echomsg a:msg
	call add(s:error, a:msg)
endfunction


function! vimrc#print_error_in_splash()
	if argc() == 0 && bufnr('$') == 1
		for err in s:error
			call append(line('$'), err)
		endfor
	endif
endfunction
" }}}


" auto loading after/colors {{{
function! vimrc#load_after_colors()
	if empty(get(g:, 'colors_name', ''))
		return
	endif
	let color = expand('~/.vim/after/colors/' . g:colors_name . '.vim')
	if filereadable(color)
		execute 'source' color
	endif
endfunction
" }}}


" statusline {{{
function! vimrc#set_statusline_nc()
	let &l:statusline = s:make_statusline(3, 4)
endfunction


function! vimrc#set_statusline()
	let &l:statusline = s:make_statusline(1, 2)
endfunction


function! s:make_statusline(hi1, hi2)
	let st = join([
	\	'%' . a:hi2 . '* %{&ft} ',
	\	'%' . a:hi1 . '* %h%w%m%r ',
	\	'%0* %<%f ',
	\	'%=',
	\	'%0* %{(&fenc != "") ? &fenc : &enc} ',
	\	'%' . a:hi1 . '* %{&ff} ',
	\	'%' . a:hi2 . '* %lL %2vC %3p%%',
	\], '')
	return st
endfunction
" }}}


" tabline {{{
function! vimrc#tabline()
	let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
	let tabpages = join(titles, '') . ' ' . '%#TabLineFill#%T'
	let info = fnamemodify(getcwd(), ':~') . ' '
	return tabpages . '%=' . info
endfunction


function! s:tabpage_label(n)
	let title = s:tabpage_title(a:n)
	let bufnrs = tabpagebuflist(a:n)
	let mods = filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')
	let mod = len(mods) ? '*' : ''
	let label = ' ' . title . mod . ' '
	let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
	return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction


function! s:tabpage_title(n)
	let bufnrs = tabpagebuflist(a:n)
	let title = gettabvar(a:n, '__title__')
	if !len(title)
		let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]
		let title = fnamemodify(bufname(curbufnr), ':t')
		let title = len(title) ? title : '[No Name]'
	endif
	return title
endfunction


function! vimrc#set_tabpage_title(title)
	if !empty(a:title)
		let t:__title__ = a:title
	else
		let n = tabpagenr()
		let title = input("Tab's title : ", s:tabpage_title(n))
		if !empty(title)
			let t:__title__ = title
		endif
	endif
	redraw!
endfunction
" }}}


" generate random string {{{
function! s:rand(n)
	" http://vim-jp.org/vim-users-jp/2009/11/05/Hack-98.html
	let match_end = matchend(reltimestr(reltime()), '\d\+\.') + 1
	return reltimestr(reltime())[match_end : ] % (a:n + 1)
endfunction


function! s:random_char_array(chars, n)
	let arr = []
	let chars = split(a:chars, '\ze')
	let max = len(chars) - 1
	for x in range(a:n)
		call add(arr, (chars[s:rand(max)]))
	endfor
	return arr
endfunction


function! vimrc#random_string(n)
	let s = s:random_char_array('0123456789abcdefghijklmnopqrstuvwxyz', a:n)
	return join(s, '')
endfunction
" }}}


" generate UUID version 4 {{{
function! vimrc#uuid()
	return substitute(s:uuid(), '\n', '', 'g')
endfunction


function! s:uuid()
	if executable('uuidgen')
		return system('uuidgen')
	endif
	if executable('python')
		return system("python -c 'import uuid;print uuid.uuid4()'")
	endif
	if executable('groovy')
		return system("groovy -e 'println UUID.randomUUID().toString()'")
	endif
	echoerr 'Need uuidgen or python or groovy'
endfunction
" }}}


" remove last element if a string in command line is like path string {{{
function! s:do_original_c_w()
	call feedkeys("\<C-w>", 'n')
	return getcmdline()
endfunction


function! vimrc#remove_path_element()
	if getcmdtype() != ':'
		return s:do_original_c_w()
	endif
	if getcmdpos() != len(getcmdline()) + 1 " cursor position is not end of line
		return s:do_original_c_w()
	endif

	let sep = '/' " TODO support windows
	let parts = split(getcmdline(), sep)

	if len(parts) > 1 " may be path string
		call remove(parts, -1)
		return join(parts, sep) . sep
	endif

	return s:do_original_c_w()
endfunction
" }}}


" delete buffers without breaking window layout {{{
function! vimrc#delete_buffer()
	if (empty(bufname('%')))
		" no operation
		return
	endif

	let curr = bufnr('%')
	let prev = bufnr('#')

	if (prev > 0 && buflisted(prev) && curr != prev)
		execute 'buffer' prev
	else
		enew
	endif

	if (curr && buflisted(curr))
		execute 'bdelete' curr
	endif
endfunction
" }}}


" messages {{{
function! vimrc#clear_messages()
	for n in range(200)
		echomsg ''
	endfor
endfunction


function! vimrc#copy_messages()
	redir @*>
	silent messages
	redir END
	call s:copy_register('*', '+')
endfunction


function! s:copy_register(from, to)
	call setreg(a:to, getreg(a:from, 1), getregtype(a:from))
endfunction
" }}}


" search with the selected text {{{
" ref. http://vim-jp.org/vim-users-jp/2009/11/25/Hack-104.html
function! s:get_selected_text()
	let tmp = @v
	silent normal! gv"vy
	let selected = @v
	let @v = tmp
	return selected
endfunction


function! vimrc#search_with_selected_text()
	let text = s:get_selected_text()
	let @/ = '\V' . substitute(escape(text, '\/'), "\n", '\\n', 'g')
	call histadd('/', @/)
endfunction
" }}}


" identify the syntax highlighting group used at the cursor {{{
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
function! vimrc#show_hilite()
	let l = line('.')
	let c = col('.')
	let hilite = ''
	let hilite .= 'hilite <' . synIDattr(synID(l, c, 1), 'name') . '>, '
	let hilite .= 'trans <' . synIDattr(synID(l, c, 0), 'name') . '>, '
	let hilite .= 'link <' . synIDattr(synIDtrans(synID(l, c, 1)), 'name') . '>'
	echo hilite
endfunction
" }}}


" quickrun sql {{{
function! vimrc#get_oracle_conn(mode)
	let user_pass = s:get_option('oracle_user_pass', 'system/oracle')
	let sid = s:get_option('oracle_sid', 'localhost/xe')
	let sep = (a:mode == 'quickrun') ? '\@' : '@'
	let conn = user_pass . sep . sid
	return conn
endfunction


function! s:get_option(option_name, ...)
	if exists('b:' . a:option_name)
		return eval('b:' . a:option_name)
	endif
	if exists('g:' . a:option_name)
		return eval('g:' . a:option_name)
	endif
	if a:0 > 0
		" default value
		return a:1
	endif
endfunction
" }}}


" unite {{{
function! vimrc#unite_converter_short_path(candidates, context)
	let home = expand('~')
	let sep = '/'

	for candidate in a:candidates
		let path = candidate.word

		if path =~# '^' . home . sep
			let path = fnamemodify(path, ':~')
		endif

		let parts = split(path, sep, 1)
		let n = len(parts)
		if n > 5
			" shorten middle path elements
			let path = join(parts[0:2], sep)
			\	. sep . pathshorten(join(parts[3:n-3], sep))
			\	. sep . join(parts[n-2:], sep)
		endif

		let candidate.abbr = path
	endfor
	return a:candidates
endfunction
" }}}


" greprep {{{
function! vimrc#greprep(grep_args)
	if !exists(':Qfreplace')
		echoerr 'Need :Qfreplace (https://github.com/thinca/vim-qfreplace)'
		return
	endif
	silent execute 'grep' a:grep_args
	Qfreplace
endfunction
" }}}


" handle E149: Sorry, no help for xxx {{{
function! vimrc#help_with_trailing_atmark()
	if getcmdtype() != ':'
		return 0
	endif
	return s:is_invalid_help_arg(getcmdline())
endfunction


function! s:is_invalid_help_arg(cmd)
	let re = '^\s*h\%[elp]\s\+.*@\s*$'
	if a:cmd !~# re
		return 0
	endif

	let arg = split(a:cmd, '\s', 0)[1]
	if arg =~# '[^g:@\-]@$'
		return 1
	endif

	for s in ['viminfo-@@', 'let-@@', ':let-@@', 'i_CTRL-@@', 'g@@', '@@@', ':@@@']
		if s ==? arg
			return 1
		endif
	endfor

	return 0
endfunction
" }}}


" directory {{{
function! vimrc#cd(directory)
	if a:directory == ''
		lcd %:p:h
	else
		execute 'lcd' a:directory
	endif
endfunction


function! vimrc#mkdir(dir)
	if isdirectory(a:dir)
		return
	endif
	call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
endfunction
" }}}


" operator {{{
function! vimrc#operator_replace_do(motionwise)
	return s:virtualedit_friendly(function('operator#replace#do'), a:motionwise)
endfunction


function! vimrc#operator_siege_add(motionwise)
	return s:virtualedit_friendly(function('operator#siege#add'), a:motionwise)
endfunction


function! vimrc#operator_siege_change(motionwise)
	return s:virtualedit_friendly(function('operator#siege#change'), a:motionwise)
endfunction


function! vimrc#operator_siege_prepare_to_change()
	let ret = operator#siege#prepare_to_change()
	return substitute(ret, '(operator-siege-%change)', '(operator-my-siege-%change)', '')
endfunction


function! s:virtualedit_friendly(fn, motionwise)
	let saved = &virtualedit
	set virtualedit&
	let ret = a:fn(a:motionwise)
	let &virtualedit = saved
	return ret
endfunction
" }}}


" misc. {{{
function! vimrc#toggle_option(option_name)
	execute 'setlocal' a:option_name . '!'
	execute 'setlocal' a:option_name . '?'
endfunction


function! vimrc#cmd_capture(q_args)
	redir => output
	silent execute a:q_args
	redir END
	let output = substitute(output, '^\n\+', '', '')

	belowright new

	silent file `=printf('[Capture: %s]', a:q_args)`
	setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
	call setline(1, split(output, '\n'))
endfunction


function! vimrc#underline(chars)
	let chars = empty(a:chars) ? '-' : a:chars
	let nr_columns = virtcol('$') - 1
	let uline = repeat(chars, (nr_columns / len(chars)) + 1)
	put =strpart(uline, 0, nr_columns)
endfunction


function! vimrc#search_without_move()
	let @/ = '\<' . expand('<cword>') . '\>'
	call histadd('/', @/)
endfunction


function! vimrc#maximize_winheight_in_help()
	if &filetype != 'help'
		return
	endif
	call feedkeys("\<C-w>_", 'n')
endfunction


function! vimrc#config_in_diff_mode()
	if !&diff
		return
	endif
	nnoremap <buffer> <C-k>  [c
	nnoremap <buffer> <C-j>  ]c
endfunction


function! vimrc#ignore_invalid_file(file)
	echoerr 'Invalid file name: "' . a:file . '"'
endfunction
" }}}


let vimrc#loading = 0

" vim: set noexpandtab :
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
