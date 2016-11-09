" ============================================================================ "
"                             functions for vimrc                              "
" ============================================================================ "

if exists('vimrc#loading') && vimrc#loading
	finish
endif

let vimrc#loading = 1


" handle environment-specific vimrc {{{
let s:error = []

function! vimrc#load_local_vimrc(...) abort
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


function! s:err(msg) abort
	echomsg a:msg
	call add(s:error, a:msg)
endfunction


function! vimrc#print_error_in_splash() abort
	if vimrc#is_in_splash()
		for err in s:error
			call append(line('$'), err)
		endfor
	endif
endfunction


function! vimrc#is_in_splash() abort
	return argc() == 0 && bufnr('$') == 1
endfunction
" }}}


" auto loading after/colors {{{
function! vimrc#load_after_colors() abort
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
function! vimrc#set_statusline_nc() abort
	let &l:statusline = s:make_statusline(3, 4)
endfunction


function! vimrc#set_statusline() abort
	let &l:statusline = s:make_statusline(1, 2)
endfunction


function! s:make_statusline(hi1, hi2) abort
	return join([
	\	'%' . a:hi2 . '* %{&ft} ',
	\	'%' . a:hi1 . '* %h%w%m%r ',
	\	'%0* %<%f ',
	\	'%=',
	\	'%0* %{(&fenc !=# "") ? &fenc : &enc} ',
	\	'%' . a:hi1 . '* %{&ff} ',
	\	'%' . a:hi2 . '* %lL %2vC %3p%%',
	\], '')
endfunction
" }}}


" tabline {{{
function! vimrc#tabline() abort
	let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
	let tabpages = join(titles, '') . ' ' . '%#TabLineFill#%T'
	let info = fnamemodify(getcwd(), ':~') . ' '
	return tabpages . '%=' . info
endfunction


function! s:tabpage_label(n) abort
	let title = s:tabpage_title(a:n)
	let bufnrs = tabpagebuflist(a:n)
	let mods = filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')
	let mod = len(mods) ? '*' : ''
	let label = ' ' . title . mod . ' '
	let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
	return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction


function! s:tabpage_title(n) abort
	let bufnrs = tabpagebuflist(a:n)
	let title = gettabvar(a:n, '__title__')

	if !len(title)
		let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]
		let title = fnamemodify(bufname(curbufnr), ':t')
		let title = len(title) ? title : '[No Name]'
	endif

	return title
endfunction


function! vimrc#set_tabpage_title(title) abort
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
function! s:rand(n) abort
	" http://vim-jp.org/vim-users-jp/2009/11/05/Hack-98.html
	let match_end = matchend(reltimestr(reltime()), '\d\+\.') + 1
	return reltimestr(reltime())[match_end : ] % (a:n + 1)
endfunction


function! s:random_char_array(chars, n) abort
	let arr = []
	let chars = split(a:chars, '\ze')
	let max = len(chars) - 1

	for x in range(a:n)
		call add(arr, (chars[s:rand(max)]))
	endfor

	return arr
endfunction


function! vimrc#random_string(n) abort
	let s = s:random_char_array('0123456789abcdefghijklmnopqrstuvwxyz', a:n)
	return join(s, '')
endfunction
" }}}


" generate UUID version 4 {{{
function! vimrc#uuid() abort
	return substitute(s:uuid(), '\n', '', 'g')
endfunction


function! s:uuid() abort
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
function! s:do_original_c_w() abort
	call feedkeys("\<C-w>", 'n')
	return getcmdline()
endfunction


function! vimrc#remove_path_element() abort
	if getcmdtype() !=# ':'
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
function! vimrc#delete_buffer() abort
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
function! vimrc#clear_messages() abort
	for n in range(200)
		echomsg ''
	endfor
endfunction


function! vimrc#copy_messages() abort
	redir @*>
	silent messages
	redir END
	call s:copy_register('*', '+')
endfunction


function! s:copy_register(from, to) abort
	call setreg(a:to, getreg(a:from, 1), getregtype(a:from))
endfunction
" }}}


" search with the selected text {{{
" ref. http://vim-jp.org/vim-users-jp/2009/11/25/Hack-104.html
function! s:get_selected_text() abort
	let tmp = @v
	silent normal! gv"vy
	let selected = @v
	let @v = tmp
	return selected
endfunction


function! vimrc#search_with_selected_text() abort
	let text = s:get_selected_text()
	let @/ = '\C\V' . substitute(escape(text, '\/'), "\n", '\\n', 'g')
	call histadd('/', @/)
endfunction
" }}}


" identify the syntax highlighting group used at the cursor {{{
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
function! vimrc#show_hilite() abort
	let l = line('.')
	let c = col('.')

	echo join([
	\	'hilite <' . synIDattr(synID(l, c, 1), 'name') . '>',
	\	'trans <' . synIDattr(synID(l, c, 0), 'name') . '>',
	\	'link <' . synIDattr(synIDtrans(synID(l, c, 1)), 'name') . '>',
	\], ', ')
endfunction
" }}}


" quickrun {{{
function! vimrc#get_oracle_conn(mode) abort
	let user_pass = s:get_option('oracle_user_pass', 'system/oracle')
	let sid = s:get_option('oracle_sid', 'localhost/xe')
	let sep = (a:mode ==# 'quickrun') ? '\@' : '@'
	let conn = user_pass . sep . sid
	return conn
endfunction


function! s:get_option(option_name, ...) abort
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


function! vimrc#quickrun_config_for_markdown(css) abort
	return {
	\	'__setup__': 'go get github.com/russross/blackfriday-tool',
	\	'command': 'blackfriday-tool',
	\	'cmdopt': '-css=' . $HOME . '/Dropbox/Work/config/marked/' . a:css,
	\	'tempfile': '%{tempname()}.md',
	\	'exec': '%c %o %a %s',
	\	'outputter': 'browser',
	\}
endfunction
" }}}


" unite {{{
function! vimrc#unite_converter_short_path(candidates, context) abort
	let home = expand('~')
	let sep = '/'

	for candidate in a:candidates
		let path = candidate.word
		let candidate.abbr = s:shorten_path(path, home, sep)
	endfor

	return a:candidates
endfunction


function! vimrc#unite_converter_simple_buffer(candidates, context) abort
	let home = expand('~')
	let sep = '/'

	for candidate in a:candidates
		let bufname = bufname(candidate.action__buffer_nr)
		let path = s:shorten_path(fnamemodify(bufname, ':p'), home, sep)
		let candidate.abbr = printf('%s', path)
	endfor

	return a:candidates
endfunction


function! s:shorten_path(path, home, sep) abort
	let path = a:path

	if path =~# '^' . a:home . a:sep
		let path = fnamemodify(path, ':~')
	endif

	let parts = split(path, a:sep, 1)
	let n = len(parts)

	if n > 5
		" shorten middle path elements
		let path = join(parts[0:2], a:sep)
		\	. a:sep . pathshorten(join(parts[3:n-3], a:sep))
		\	. a:sep . join(parts[n-2:], a:sep)
	endif

	return path
endfunction


function! vimrc#unite_grep(...) abort
	let dir = get(a:, 1, '')
	let inc = get(a:, 2, '*')
	let pat = get(a:, 3, '')
	execute printf('Unite grep:%s:-r\\ --include=%s:%s -no-auto-preview', dir, inc, pat)
endfunction
" }}}


" greprep {{{
function! vimrc#greprep(grep_args) abort
	if !exists(':Qfreplace')
		echoerr 'Need :Qfreplace (https://github.com/thinca/vim-qfreplace)'
		return
	endif

	silent execute 'grep' a:grep_args
	Qfreplace
endfunction
" }}}


" handle E149: Sorry, no help for xxx {{{
function! vimrc#help_with_trailing_atmark() abort
	if getcmdtype() !=# ':'
		return 0
	endif

	return s:is_invalid_help_arg(getcmdline())
endfunction


function! s:is_invalid_help_arg(cmd) abort
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


" file {{{
function! vimrc#ignore_invalid_file(file) abort
	echoerr 'Invalid file name: "' . a:file . '"'
endfunction


function! vimrc#rename_file(new_file_path) abort
	execute 'file ' . a:new_file_path
	write
	call delete(expand('#'))
endfunction


function! vimrc#reload_file() abort
	let file = expand('%:p')
	call vimrc#delete_buffer()
	execute 'edit ' . file
endfunction
" }}}


" directory {{{
function! vimrc#cd(directory) abort
	if a:directory ==# ''
		lcd %:p:h
	else
		execute 'lcd' a:directory
	endif
endfunction


function! vimrc#dir(dir) abort
	call vimrc#mkdir(a:dir)
	return a:dir
endfunction


function! vimrc#mkdir(dir) abort
	if isdirectory(a:dir)
		return
	endif

	call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
endfunction
" }}}


" operator {{{
function! vimrc#operator_replace_do(motionwise) abort
	return s:virtualedit_friendly(function('operator#replace#do'), a:motionwise)
endfunction


function! vimrc#define_operator_my_siege_add() abort
	call operator#user#define('my-siege-add', 'vimrc#operator_siege_add',
	\	'call operator#siege#prepare_to_add(0)')
endfunction


function! vimrc#operator_siege_add(motionwise) abort
	return s:virtualedit_friendly(function('operator#siege#add'), a:motionwise)
endfunction


function! vimrc#define_operator_my_siege_change() abort
	call operator#user#define('my-siege-%change', 'vimrc#operator_siege_change')
	nmap <expr> <Plug>(operator-my-siege-change)  vimrc#operator_siege_prepare_to_change()
	vnoremap <Plug>(operator-my-siege-change)  <Nop>
	onoremap <Plug>(operator-my-siege-change)  <Nop>
endfunction


function! vimrc#operator_siege_change(motionwise) abort
	return s:virtualedit_friendly(function('operator#siege#change'), a:motionwise)
endfunction


function! vimrc#operator_siege_prepare_to_change() abort
	let ret = operator#siege#prepare_to_change()
	return substitute(ret, '(operator-siege-%change)', '(operator-my-siege-%change)', '')
endfunction


function! s:virtualedit_friendly(fn, motionwise) abort
	let saved = &virtualedit
	set virtualedit&
	let ret = a:fn(a:motionwise)
	let &virtualedit = saved
	return ret
endfunction
" }}}


" urlencode/urldecode {{{
function! vimrc#urldecode(str) abort
	return eval('"' . substitute(a:str, '%', '\\x', 'g') . '"')
endfunction


function! vimrc#urlencode(str) abort
	let encoded = []

	let len = strlen(a:str)
	let i = 0

	while i < len
		let hex = s:nr2hex(char2nr(a:str[i]))
		let pad = (strlen(hex) < 2) ? '0' : ''
		call add(encoded, '%' . pad . hex)
		let i += 1
	endwhile

	return join(encoded, '')
endfunction


function! s:nr2hex(nr) abort
	let hex = ''
	let n = a:nr

	while n != 0
		let hex = '0123456789ABCDEF'[n % 16] . hex
		let n = n / 16
	endwhile

	return hex
endfunction
" }}}


" sonictemplate {{{
function! vimrc#apply_template() abort
	let pos = getpos('.')
	let line = getline('.')
	let name_hint = s:extract_name_hint(line, pos)
	let names = sonictemplate#complete(name_hint, '', 0)

	if len(names) != 1
		call feedkeys("\<Esc>:Template " . name_hint . "\<C-l>", 'n')
		return
	endif

	execute 'Template ' . names[0]
endfunction


function! s:extract_name_hint(line, pos) abort
	let col = a:pos[2]
	let hint = []

	for i in range(col)
		let char = a:line[col - i - 1]

		if char !~# '[0-9a-zA-Z_-]'
			let i -= 1
			break
		endif

		call add(hint, char)
	endfor

	call s:remove_name_hint(col, i)

	return join(reverse(hint), '')
endfunction


function! s:remove_name_hint(col, i) abort
	let begin = a:col - a:i
	let end = a:col + 1
	execute 's/\%' . begin . 'c.*\%' . end . 'c//'
endfunction
" }}}


" input {{{
function! vimrc#input_pair_char_nicely(char, ...) abort
	let line = getline('.')
	let col = col('.')
	let prev_char = line[col - 2]
	let next_char = line[col - 1]

	if next_char ==# a:char
		return "\<Right>"
	endif

	if a:0 > 0
		for prev_str in a:1
			if line[col - len(prev_str) - 1:col - 2] ==# prev_str
				return a:char . a:char . "\<Left>"
			endif
		endfor

		return a:char
	endif

	let re = '\w\|\\'

	if prev_char =~# re || next_char =~# re
		return a:char
	endif

	return a:char . a:char . "\<Left>"
endfunction


function! vimrc#input_open_char_nicely(open, close) abort
	let surround = s:get_surround_chars()

	if a:open . a:close ==# surround
		return a:open . a:close . "\<Left>"
	endif

	if surround[1] ==# a:close
		return a:open
	endif

	return a:open . a:close . "\<Left>"
endfunction


function! vimrc#input_close_char_nicely(open, close) abort
	let surround = s:get_surround_chars()

	if a:open . a:close ==# surround
		return "\<Right>"
	endif

	return a:close
endfunction


function! vimrc#input_cr_nicely() abort
	if pumvisible()
		return "\<C-y>"
	endif

	let surround = s:get_surround_chars()

	if s:contains(['()', '{}', '[]'], surround)
		return "\<CR>\<CR>\<Up>\<Tab>"
	endif

	return "\<CR>"
endfunction


function! vimrc#input_bs_nicely() abort
	let surround = s:get_surround_chars()

	if s:contains(['()', '{}', '[]'], surround)
		return "\<BS>\<Delete>"
	endif

	return "\<BS>"
endfunction


function! s:get_surround_chars() abort
	let line = getline('.')
	let col = col('.')
	return line[col - 2:col - 1]
endfunction


function! s:contains(list, elem) abort
	return index(a:list, a:elem) >= 0
endfunction
" }}}


" plugin {{{
function! vimrc#plugin_exists(name) abort
    return !empty(glob(expand('~/.vim/plugins/' . a:name)))
endfunction
" }}}


" misc. {{{
function! vimrc#toggle_option(option_name) abort
	execute 'setlocal' a:option_name . '!'
	execute 'setlocal' a:option_name . '?'
endfunction


function! vimrc#cmd_capture(q_args) abort
	redir => output
	silent execute a:q_args
	redir END
	let output = substitute(output, '^\n\+', '', '')

	belowright new

	silent file `=printf('[Capture: %s]', a:q_args)`
	setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
	call setline(1, split(output, '\n'))
endfunction


function! vimrc#underline(chars) abort
	let chars = empty(a:chars) ? '-' : a:chars
	let nr_columns = virtcol('$') - 1
	let uline = repeat(chars, (nr_columns / len(chars)) + 1)
	put =strpart(uline, 0, nr_columns)
endfunction


function! vimrc#search_without_move() abort
	let @/ = '\C\<' . expand('<cword>') . '\>'
	call histadd('/', @/)
endfunction


function! vimrc#config_in_diff_mode() abort
	if !&diff
		return
	endif

	nnoremap <buffer> <C-k>  [c
	nnoremap <buffer> <C-j>  ]c
endfunction


function! vimrc#sort_lines(bang) range abort
	let range = a:firstline . ',' . a:lastline
	silent execute range . 's/^\(.*\)$/\=strdisplaywidth(submatch(0)) . " " . submatch(0)/'
	silent execute range . 'sort' . a:bang . ' n'
	silent execute range . 's/^\d\+ //'
endfunction


function! vimrc#reverse_lines() range abort
	let range = a:firstline . ',' . a:lastline
	execute range . 'g/^/m' . (a:firstline - 1)
	call histdel('search', -1)
endfunction


function! vimrc#fname(name, sfile) abort
	let sid = matchstr(a:sfile, '<SNR>\zs\d\+\ze_.\+$')
	return printf('<SNR>%s_%s', sid, a:name)
endfunction


let vimrc#tmp_dir = vimrc#dir(expand('~/tmp/vim'))
let vimrc#undo_dir = vimrc#dir(vimrc#tmp_dir . '/undo')
" }}}


let vimrc#loading = 0

" vim: set noexpandtab :
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
