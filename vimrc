" ============================================================================ "
"                                    vimrc                                     "
" ============================================================================ "


" basic {{{
" ------------------------------------------------------------------------------
" encoding {{{
" `set encoding=utf8` *must* be before `scriptencoding utf8`
" because `scriptencoding utf-8` converts source string
" from its argument encoding to current `&encoding`.
set encoding=utf-8
scriptencoding utf-8
set fileencodings=ucs-bom,iso-2022-jp,euc-jp,utf-8,cp932,utf-16le,utf-16
" }}}

" clear command
augroup my
	autocmd!
augroup end

" user interface in English
language messages C
language time C

let g:did_install_default_menus = 1

function! s:load_local_vimrc(...)
	let suffix = (a:0 > 0) ? ('.' . a:1) : ''
	let vimrc = expand('~/.vimrc.local' . suffix)
	if filereadable(vimrc)
		try
			execute 'source' vimrc
		catch
		" TODO do not ignore errors
		endtry
	endif
endfunction

" load local config
call s:load_local_vimrc('prepare')

" environment {{{
let s:in_win = has('win32') || has('win64')
let s:in_mac = has('mac') || has('macunix')
let s:in_nix = !s:in_mac && has('unix')
" }}}

" map leader {{{
let mapleader = ','
let maplocalleader = '\'
" }}}

syntax enable

" runtimepath {{{
filetype off

" bundle {{{
execute 'source' expand('~/.vim/bundles.vim')
" }}}

" after bundling, enable filetype
filetype plugin on
filetype indent on
" /runtimepath }}}

" color {{{
" auto loading after/colors {{{
function! s:load_after_colors()
	let color = expand('~/.vim/after/colors/' . g:colors_name . '.vim')
	if filereadable(color)
		execute 'source' color
	endif
endfunction
autocmd my ColorScheme * call s:load_after_colors()
" }}}
autocmd my ColorScheme *  highlight link FullWidthSpace SpellBad
autocmd my Syntax *  syntax match FullWidthSpace containedin=ALL /　/

set background=dark
colorscheme scheakur
" }}}


" /basic }}}


" option {{{
" ------------------------------------------------------------------------------
" search {{{
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
" }}}

" characters {{{
set fileformats=unix,dos,mac
set ambiwidth=double
" }}}

" indent {{{
set smarttab
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop&
set shiftround

" for Vim script. see help: ft-vim-indent
let g:vim_indent_cont=0
" }}}

" matching parenthesis {{{
set showmatch
set matchtime=2
set cpoptions-=m
set matchpairs+=<:>
" }}}

" fold {{{
set foldenable
set foldmethod=marker
" vert:\| is default
set fillchars=fold:\ ,vert:\|
" for xml folding
let g:xml_syntax_folding = 1
" }}}

" backup & swap & undo {{{
set nowritebackup
set nobackup
set directory-=.
let &directory = $HOME . '/tmp/vim,' . &directory
set undofile
let &undodir = $HOME . '/tmp/vim/undo,' . &directory
" make tmp directory
if !isdirectory($HOME . '/tmp/vim/undo')
	call mkdir($HOME . '/tmp/vim/undo', 'p')
endif
set history=1024
set viminfo='128,<512,s64,h
" }}}

" invisible characters {{{
set list
set listchars=tab:»_,trail:･
" highlight column 81
set colorcolumn=81
set textwidth=0
" }}}

" footer (statusline, cmdheight) {{{
set cmdheight=2
set laststatus=2

autocmd my BufLeave,WinLeave * call s:set_statusline_nc()
autocmd my BufEnter,WinEnter * call s:set_statusline()

function! s:set_statusline_nc()
	let &l:statusline = s:make_statusline(3, 4)
endfunction

function! s:set_statusline()
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

" misc {{{
set hidden
set backspace=indent,eol,start
set clipboard=unnamed
if has('unnamedplus')
	set clipboard+=unnamedplus
endif
set modeline
" Do not increase/decrease as octal number or hexadecimal number
set nrformats& nrformats-=octal,hex
set virtualedit=all
set formatoptions=tcroqnlM1
" show the number of lines of selection
set showcmd
set updatetime=1000
set maxfuncdepth=256
" show preview window at the bottom
set splitbelow
" }}}

" tabpages {{{
set showtabline=2
set tabline=%!MyTabLine()

function! MyTabLine()
	let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
	let tabpages = join(titles, '') . ' ' . '%#TabLineFill#%T'
	let info = fnamemodify(getcwd(), ":~") . ' '
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

function! s:set_tabpage_title(title)
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

command! -nargs=? SetTabTitle  call s:set_tabpage_title(<q-args>)
" }}}

" completion {{{
set wildignore& wildignore+=.git,.svn,*.class
set nowildmenu
set wildmode=list:longest,full
" }}}

" /option }}}


" command {{{
" ------------------------------------------------------------------------------

" file encoding & line feed code {{{
command! -bang -bar -complete=file -nargs=? Utf8
\	edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp
\	edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932
\	edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc
\	edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16
\	edit<bang> ++enc=utf-16le <args>
command! -bang -bar -complete=file -nargs=? Utf16be
\	edit<bang> ++enc=utf-16 <args>

command! -bang -bar -complete=file -nargs=? Unix
\	edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac
\	edit<bang> ++fileformat=mac <args>
command! -bang -bar -complete=file -nargs=? Dos
\	edit<bang> ++fileformat=dos <args>
" }}}

" remove spaces {{{
command! -range=% TrimSpace  <line1>,<line2>s!\s*$!!g | nohlsearch

command! -range ShrinkSpace
\	<line1>,<line2>s![^ ]\zs\s\{2,}! !g
\	| normal gv
\	| nohlsearch
" }}}

" insert a blank line every N lines {{{
command! -range -nargs=1 InsertBlankLineEvery
\	<line1>,<line2>s!\v(.*\n){<args>}!&\r
\	| nohlsearch
" }}}

" rename file
command! -nargs=1 -complete=file Rename  f <args>|w|call delete(expand('#'))

" remove trail ^M
command! -range=% RemoveTrailM  <line1>,<line2>s!\r$!!g | nohlsearch

" command CD {{{
command! -nargs=? -complete=dir -bang CD  call s:change_dir('<args>', '<bang>')
function! s:change_dir(directory, bang)
	if a:directory == ''
		lcd %:p:h
	else
		execute 'lcd' a:directory
	endif
	if a:bang == ''
		pwd
	endif
endfunction
nnoremap <silent> <Space>cd  :<C-u>CD<CR>
" }}}

" format JSON
command! -range FormatJson  <line1>,<line2>!python -m json.tool

" capture outputs of command {{{
" ref. http://d.hatena.ne.jp/tyru/20100427/vim_capture_command
command! -nargs=+ -complete=command Capture  call s:cmd_capture(<q-args>)

function! s:cmd_capture(q_args) " {{{
	redir => output
	silent execute a:q_args
	redir END
	let output = substitute(output, '^\n\+', '', '')

	belowright new

	silent file `=printf('[Capture: %s]', a:q_args)`
	setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
	call setline(1, split(output, '\n'))
endfunction " }}}
" }}}

" draw underline " {{{
" ref. http://vim.wikia.com/wiki/Underline_using_dashes_automatically
command! -nargs=? Underline  call s:underline(<q-args>)

function! s:underline(chars)
	let chars = empty(a:chars) ? '-' : a:chars
	let nr_columns = virtcol('$') - 1
	let uline = repeat(chars, (nr_columns / len(chars)) + 1)
	put =strpart(uline, 0, nr_columns)
endfunction
" }}}

" delete buffers without breaking window layout {{{
command! Bdelete  call s:delete_buffer()

function! s:delete_buffer()
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

" clear quickfix list
command! Qclear  call setqflist([])

" clear location list
command! Lclear  call setloclist(0, [])


command! -nargs=0 RandomString call s:random_string(8)

function! s:rand(n)
	" http://vim-users.jp/2009/11/hack98/
	let match_end = matchend(reltimestr(reltime()), '\d\+\.') + 1
	return reltimestr(reltime())[match_end : ] % (a:n + 1)
endfunction

function! s:random_string(n)
	let s = []
	let chars = split('0123456789abcdefghijklmnopqrstuvwxyz', '\ze')
	let max = len(chars) - 1
	for x in range(a:n)
		call add(s, (chars[s:rand(max)]))
	endfor
	let @+ = join(s, '')
endfunction

" /command }}}


" keymap {{{
" ------------------------------------------------------------------------------

" vimrc {{{
nnoremap <Space>s.  :<C-u>source $MYVIMRC<CR>
nnoremap <Space>.  :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>s>  :<C-u>source ~/.gvimrc<CR>
nnoremap <Space>>  :<C-u>edit ~/.gvimrc<CR>
" }}}

" basic {{{
noremap ;  :
noremap :  ;
noremap '  `
noremap `  '
noremap j  gj
noremap k  gk
noremap gj  j
noremap gk  k
nnoremap J  <C-d>
nnoremap K  <C-u>
nnoremap <Space>j  16j
nnoremap <Space>k  16k
noremap H  b
noremap L  w
nnoremap Y  y$
nnoremap <silent> n  nzz
nnoremap <silent> N  Nzz
nnoremap <C-o>  <C-o>zz
nnoremap <C-i>  <C-i>zz

nnoremap gm  `[v`]
vnoremap gm  :<C-u>normal gm<CR>
onoremap gm  :<C-u>normal gm<CR>

inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-d>  <Delete>
nnoremap <silent> O  :<C-u>call append(expand('.'), '')<CR>j
nnoremap <Space>M  :<C-u>marks<CR>:mark<Space>
" }}}

" copy(yank) and paste with clipboard {{{
if s:in_nix
	inoremap <C-o>p  <C-r><C-o>+
	cnoremap <C-o>p  <C-r><C-o>+
	vnoremap <C-o>y  "+y
	vnoremap <C-o>Y  "+y$
else
	inoremap <C-o>p  <C-r><C-o>*
	cnoremap <C-o>p  <C-r><C-o>*
	vnoremap <C-o>y  "*y
	vnoremap <C-o>Y  "*y$
endif
" }}}

" command line mode {{{
cnoremap <C-a>  <Home>
cnoremap <C-e>  <End>
cnoremap <M-l>  <Right>
cnoremap <M-h>  <Left>
cnoremap <expr> /  (getcmdtype() == '/') ? '\/' : '/'
cnoremap <expr> ?  (getcmdtype() == '?') ? '\?' : '?'
cnoremap <C-p>  <Up>
cnoremap <Up>  <C-p>
cnoremap <C-n>  <Down>
cnoremap <Down>  <C-n>
" }}}

" toggle option {{{
function! s:toggle_option(option_name)
	execute 'setlocal' a:option_name . '!'
	execute 'setlocal' a:option_name . '?'
endfunction
nnoremap <silent> <Space>ow  :<C-u>call <SID>toggle_option('wrap')<CR>
nnoremap <silent> <Space>nu  :<C-u>call <SID>toggle_option('number')<CR>
nnoremap <silent> <Space>hl  :<C-u>call <SID>toggle_option('hlsearch')<CR>
nnoremap <silent> <Space>et  :<C-u>call <SID>toggle_option('expandtab')<CR>
" }}}

" current date/time {{{
inoremap <Leader>dF  <C-r>=strftime('%Y-%m-%dT%H:%M:%S%z')<CR>
inoremap <Leader>df  <C-r>=strftime('%Y-%m-%d %H:%M:%S')<CR>
inoremap <Leader>dd  <C-r>=strftime('%Y-%m-%d')<CR>
inoremap <Leader>dm  <C-r>=strftime('%Y-%m')<CR>
inoremap <Leader>dy  <C-r>=strftime('%Y')<CR>
inoremap <Leader>dT  <C-r>=strftime('%H:%M:%S')<CR>
inoremap <Leader>dt  <C-r>=strftime

cnoremap <expr> <C-o>d  strftime('%Y-%m-%d')
cnoremap <expr> <C-o>t  strftime('%Y-%m-%d-%H%M%S')
" }}}

" completion {{{
imap <C-Space>  <C-@>
inoremap <C-@>  <C-n>
" }}}

" text-objects {{{
" <angle>
onoremap aa  a>
vnoremap aa  a>
onoremap ia  i>
vnoremap ia  i>

" [rectangle]
onoremap ar  a]
vnoremap ar  a]
onoremap ir  i]
vnoremap ir  i]

" 'quote'
onoremap aq  a'
vnoremap aq  a'
onoremap iq  i'
vnoremap iq  i'

" "double quote"
onoremap ad  a"
vnoremap ad  a"
onoremap id  i"
vnoremap id  i"

" textobj-function (default f)
omap af  <Plug>(textobj-function-a)
vmap af  <Plug>(textobj-function-a)
omap if  <Plug>(textobj-function-i)
vmap if  <Plug>(textobj-function-i)

" textobj-between (default f)
omap a;  <Plug>(textobj-between-a)
vmap a;  <Plug>(textobj-between-a)
omap i;  <Plug>(textobj-between-i)
vmap i;  <Plug>(textobj-between-i)
" }}}

" handle window {{{
nnoremap <C-w>-  <C-w>3-
nnoremap <C-w>>  <C-w>3>
nnoremap <C-w><  <C-w>3<
nnoremap <C-w>+  <C-w>3+

" split window
nmap <Space>wj  <SID>(split-to-j)
nmap <Space>wk  <SID>(split-to-k)
nmap <Space>wh  <SID>(split-to-h)
nmap <Space>wl  <SID>(split-to-l)

nnoremap <silent> <SID>(split-to-j)
\	:<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-k)
\	:<C-u>execute 'aboveleft' (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-h)
\	:<C-u>execute 'topleft' (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <silent> <SID>(split-to-l)
\	:<C-u>execute 'botright' (v:count == 0 ? '' : v:count) 'vsplit'<CR>
" }}}

" yank filename {{{
if s:in_mac
	nnoremap <silent> <Space>yf  :let @*=expand("%:p")<CR>
	nnoremap <silent> <Space>yy  :let @*=expand("%")<CR>
else
	nnoremap <silent> <Space>yf  :let @+=expand("%:p")<CR>
	nnoremap <silent> <Space>yy  :let @+=expand("%")<CR>
endif
" }}}

" quickfix {{{
nnoremap [Quickfix]  <Nop>
nmap q  [Quickfix]
nnoremap Q  q

nnoremap <silent> [Quickfix]n  :<C-u>cnext<CR>
nnoremap <silent> [Quickfix]p  :<C-u>cprevious<CR>
nnoremap <silent> [Quickfix]j  :<C-u>cnext<CR>
nnoremap <silent> [Quickfix]k  :<C-u>cprevious<CR>
nnoremap <silent> [Quickfix]r  :<C-u>crewind<CR>
nnoremap <silent> [Quickfix]N  :<C-u>cfirst<CR>
nnoremap <silent> [Quickfix]P  :<C-u>clast<CR>
nnoremap <silent> [Quickfix]fn  :<C-u>cnfile<CR>
nnoremap <silent> [Quickfix]fp  :<C-u>cpfile<CR>
nnoremap <silent> [Quickfix]l  :<C-u>clist<CR>
nnoremap <silent> [Quickfix]q  :<C-u>cc<CR>
nnoremap <silent> [Quickfix]o  :<C-u>copen<CR>
nnoremap <silent> [Quickfix]c  :<C-u>cclose<CR>
nnoremap <silent> [Quickfix]en  :<C-u>cnewer<CR>
nnoremap <silent> [Quickfix]ep  :<C-u>colder<CR>
nnoremap <silent> [Quickfix]m  :<C-u>make<CR>
" }}}

" misc {{{
function! s:search_without_move()
	let @/ = '\<' . expand('<cword>') . '\>'
	call histadd('/', @/)
endfunction

nnoremap <silent> *
\	:<C-u>call <SID>search_without_move()<CR>zz:<C-u>set hlsearch<CR>

" search with the selected text
" ref. http://vim-users.jp/2009/11/hack104/
function! s:get_selected_text()
	let tmp = @@
	silent normal! gvy
	let selected = @@
	let @@ = tmp
	return selected
endfunction

function! s:search_with_selected_text()
	let text = s:get_selected_text()
	let @/ = '\V' . substitute(escape(text, '\/'), "\n", '\\n', 'g')
	call histadd('/', @/)
endfunction

vnoremap <silent> *
\	:<C-u>call <SID>search_with_selected_text()<CR>zz:<C-u>set hlsearch<CR>
vnoremap <silent> <CR>
\	:<C-u>call <SID>search_with_selected_text()<CR>zz:<C-u>set hlsearch<CR>

" identify the syntax highlighting group used at the cursor
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
function! s:show_hilite()
	let l = line('.')
	let c = col('.')
	let hilite = ''
	let hilite .= 'hilite <' . synIDattr(synID(l, c, 1), 'name') . '>, '
	let hilite .= 'trans <' . synIDattr(synID(l, c, 0), 'name') . '>, '
	let hilite .= 'link <' . synIDattr(synIDtrans(synID(l, c, 1)), 'name') . '>'
	echo hilite
endfunction

command! ShowHilite  call s:show_hilite()
nnoremap <M-F12>  :<C-u>ShowHilite<CR>
" }}}

" hlsearch (search and highlight) {{{
nnoremap <Esc><Esc>  :<C-u>nohlsearch<CR>
" }}}

" completion {{{
inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<CR>"
" }}}

" /keymap }}}


" plugin {{{
" ------------------------------------------------------------------------------

" unite {{{

" option {{{
let g:unite_split_rule = 'aboveleft'
let g:unite_update_time = 100
" }}}

" keymap {{{
nnoremap [Unite]  <Nop>
nmap <Space>  [Unite]

nnoremap [Unite]<Space>  :<C-u>Unite<Space>
nnoremap <silent> [Unite]f  :<C-u>Unite buffer_tab file_mru file<CR>
nnoremap <silent> [Unite]g  :<C-u>UniteWithBufferDir file file_rec<CR>
nnoremap <silent> [Unite]b  :<C-u>Unite buffer_tab<CR>
nnoremap <silent> [Unite]v  :<C-u>Unite buffer<CR>
nnoremap <silent> [Unite]r  :<C-u>Unite register<CR>
nnoremap <silent> [Unite]q  :<C-u>Unite quickfix<CR>
" }}}


" change default action for buffer/buffer_tab {{{
call unite#custom_default_action('buffer_tab', 'goto')
call unite#custom_default_action('buffer', 'goto')

call unite#custom#profile('default', 'context', {
\	'no_split': 1
\})
" }}}


" unite alias {{{
let g:unite_source_alias_aliases = {
\	'opera' : {
\		'source': 'file_rec',
\		'args': expand('~/Dropbox/config/opera/'),
\	},
\	'vim' : {
\		'source': 'file_rec/async',
\		'args': expand('~/.vim/.'),
\	},
\	'keymap' : {
\		'source': 'output',
\		'args': join(['map', 'map!', 'lmap'], '|'),
\	},
\ }
" }}}

if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '-i --nocolor --nogroup'
	let g:unite_source_grep_recursive_opt = ''
endif

let g:unite_source_grep_max_candidates = 100

" /unite }}}

" commentary {{{
vmap <Space>/  <Plug>Commentary
nmap <Space>/  <Plug>CommentaryLine
" }}}

" matchit {{{
source $VIMRUNTIME/macros/matchit.vim
" }}}

" quickrun {{{

let g:quickrun_config = {
\	'_': {
\		'runner': 'vimproc',
\		'runner/vimproc/updatetime': 100,
\		'outputter/buffer/split': 'aboveleft',
\	},
\	'watchdogs_checker/_': {
\		'hook/close_quickfix/enable_exit': 1,
\		'hook/back_tabpage/enable_exit': 1,
\		'hook/back_tabpage/priority_exit': -2000,
\		'hook/back_window/enable_exit': 1,
\		'hook/back_window/priority_exit': -1000,
\	},
\	'sql': {
\		'command': 'sqlplus',
\		'cmdopt': '-S',
\		'args': '%{MyGetOracleConnection("quickrun")}',
\		'tempfile': '%{tempname()}.sql',
\		'exec': '%c %o %a \@%s',
\		'outputter/buffer/filetype': 'quickrun.sqloutput',
\	},
\	'rst': {
\		'command': 'rst2html',
\		'outputter': 'browser',
\	},
\}

if (s:in_mac)
	call extend(g:quickrun_config, {
	\	'mkd' : {
	\		'command': 'open',
	\		'cmdopt': '-a',
	\		'tempfile': '%{tempname()}.md',
	\		'exec': '%c %s %o /Applications/Marked.app',
	\		'outputter': 'null',
	\	},
	\})
endif

" to quickrun sql {{{
function! MyGetOracleConnection(mode)
	let user_pass = s:get_option('oracle_user_pass', 'system/oracle')
	let sid = s:get_option('oracle_sid', 'localhost/xe')
	let sep = (a:mode == 'quickrun') ? '\\\@' : '@'
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

" }}}

" watchdogs {{{
let g:watchdogs_check_BufWritePost_enables = {
\	'javascript': 1,
\}
" }}}

" dois.vim {{{
let g:dois_file = $HOME . '/Dropbox/tmp/doinglist.taskpaper'
let g:dois_dir = $HOME . '/Dropbox/tmp/doinglist'
nmap <C-CR>  <Plug>(dois:n:add-daily-task)
" }}}

" operator-replace {{{
nmap s  <Plug>(operator-replace)
nmap S  <Plug>(operator-replace)$<C-o>x
nmap ss  <Plug>(operator-replace)<Plug>(textobj-line-a)<C-o>x
" }}}

" neosnippet {{{
let g:neosnippet#snippets_directory = join([
\	expand('~/.vim/snippet'),
\	expand('~/.vim.local/snippet'),
\], ',')
let g:neosnippet#disable_runtime_snippets = {
\	'_' : 1,
\}
" }}}

" vim-javascript {{{
let g:html_indent_inctags = 'html,body,head,tbody,th,td,tr,tfoot,thead'
let g:html_indent_script1 = 'inc'
let g:html_indent_style1 = 'inc'
let g:javascript_enable_domhtmlcss = 1
" }}}

" vim-skrap {{{
let g:skrap_directory = expand('~/Dropbox/tmp/skrap')
let g:skrap_types = [
\	'md', 'js', 'txt', 'vim', 'sql', 'xml', 'html', 'css', 'go'
\]
" }}}

" vim-demitas {{{
let g:demitas_directory = expand('~/Dropbox/tmp/demitas')

call extend(g:unite_source_alias_aliases, {
\	'demitas' : {
\		'source': 'file_rec',
\		'args': g:demitas_directory,
\		'description': 'my tumblr files',
\	},
\})

call unite#custom_source('demitas', 'sorters', 'sorter_reverse')
" }}}

" vim-markdown {{{
let g:vim_markdown_folding_disabled = 1
" }}}

" open-browser {{{
let g:netrw_nogx = 1
nmap gx  <Plug>(openbrowser-smart-search)
vmap gx  <Plug>(openbrowser-smart-search)
" }}}

" the tab key {{{
imap <C-Tab>  <C-x><C-u>
imap <expr> <Tab>
\	neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
\	pumvisible() ? "\<C-n>" :
\	"\<Tab>"
smap <expr> <Tab>
\	neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
\	"\<Tab>"
inoremap <expr> <S-Tab>  pumvisible() ? "\<C-p>" : "\<S-Tab>"
xmap <Tab>  <Plug>(neosnippet_expand_target)
" }}}

" operator-camerize {{{
map <Leader>_  <Plug>(operator-camelize-toggle)
" }}}

" godef {{{
let g:godef_split = 0
" }}}

" altr {{{
nmap <F2>  <Plug>(altr-forward)
nmap <S-F2>  <Plug>(altr-back)
" }}}

" neomru {{{
let g:neomru#time_format = '(%m/%d %H:%M) '
" }}}

" operator-insert {{{
map <Leader>i  <Plug>(operator-insert-i)
map <Leader>a  <Plug>(operator-insert-a)
" }}}

" operator-surround {{{
map <silent> <Leader>sa <Plug>(operator-surround-append)
map <silent> <Leader>sd <Plug>(operator-surround-delete)
map <silent> <Leader>sr <Plug>(operator-surround-replace)
" }}}

" vim-repautocd {{{
let g:repautocd_markers = ['.git', '.hg', '.svn', '.gitignore']
" }}}

" /plugin }}}


" autocmd {{{
" ------------------------------------------------------------------------------

" Create non-existing diretories automatically when the file is saved.
function! s:auto_mkdir(dir)
	if isdirectory(a:dir)
		return
	endif
	call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
endfunction
autocmd my BufWritePre *  call s:auto_mkdir(expand('<afile>:p:h'))

" Open quickfix window after executing make.
autocmd my QuickfixCmdPost  make copen

" Avoid saving files with keyboard misstroke
" ref. http://d.hatena.ne.jp/tyru/20130419/avoid_tyop
function! s:ignore_invalid_file(file)
	echomsg 'Invalid file name: "' . a:file . '"'
endfunction
autocmd my BufWriteCmd *;  call s:ignore_invalid_file(expand('<afile>'))

" Reload a file on WinEnter if the file has been modified
set autoread
autocmd my WinEnter *  checktime

" key mapping in vimdiff
function! s:config_in_diff_mode()
	if !&diff
		return
	endif
	nnoremap <buffer> <C-k>  [c
	nnoremap <buffer> <C-j>  ]c
endfunction

autocmd my FilterWritePre *  call s:config_in_diff_mode()
" }}}


" finally {{{
" ------------------------------------------------------------------------------
call s:load_local_vimrc()
call watchdogs#setup(g:quickrun_config)
set secure
" /finally }}}


" @see :help modeline
" vim: set noexpandtab :
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
