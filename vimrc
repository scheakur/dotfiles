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
set fileencodings=utf-8,ucs-bom,iso-2022-jp,euc-jp,cp932,utf-16le,utf-16
" }}}

if exists('+shellslash')
	set shellslash
endif

" make vimrc reloadable
source $HOME/.vim/autoload/vimrc.vim

" clear autocmd
augroup vimrc
	autocmd!
augroup end

" user interface in English
language messages C
language time C

" environment {{{
let s:mac = has('mac') || has('macunix')
let s:nix = !s:mac && has('unix')
" }}}

if !s:mac
	let g:did_install_default_menus = 1
endif

" load local config
call vimrc#load_local_vimrc('prepare')

" map leader {{{
let g:mapleader = ','
let g:maplocalleader = '\'
" }}}

syntax enable

" runtimepath {{{
filetype off

" bundle {{{
source $HOME/.vim/bundles.vim
" }}}

" after bundling, enable filetype
filetype plugin on
filetype indent on
" /runtimepath }}}

" color {{{
" auto loading after/colors
autocmd vimrc ColorScheme *  call vimrc#load_after_colors()

" highlight full width space as bad
autocmd vimrc ColorScheme *  highlight link FullWidthSpace SpellBad
autocmd vimrc Syntax *  syntax match FullWidthSpace containedin=ALL /　/


if !has('gui_running')
	set background=dark
	colorscheme scheakur
endif

" to keep background in terminal clean
set t_ut=
set t_Co=256
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

let &showbreak = '␣'
if exists('&breakindent')
	set breakindent
	set breakindentopt=shift:-1
endif

" for Vim script. see help: ft-vim-indent
let g:vim_indent_cont = 0
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
let &directory = vimrc#tmp_dir . ',' . &directory
set undofile
let &undodir = vimrc#undo_dir . ',' . &directory
set history=1024
set viminfo='128,<512,s64,h
" }}}

" invisible characters {{{
set list
set listchars=tab:»_,trail:･,extends:>,precedes:<
" highlight column 81
set colorcolumn=81
set textwidth=0
" }}}

" footer (statusline, cmdheight) {{{
set cmdheight=2
set laststatus=2

autocmd vimrc BufLeave,WinLeave *  call vimrc#set_statusline_nc()
autocmd vimrc BufEnter,WinEnter *  call vimrc#set_statusline()
" }}}

" misc {{{
set hidden
set backspace=indent,eol,start
set clipboard=unnamed
if has('unnamedplus')
	set clipboard+=unnamedplus
endif
set modeline
" do not increase/decrease as octal number or hexadecimal number
set nrformats& nrformats-=octal,hex
set virtualedit=all
set formatoptions=tcroqnlM1j
" show the number of lines of selection
set showcmd
set updatetime=1000
set maxfuncdepth=256
" show preview window at the bottom
set splitbelow
" hide intro message
set shortmess+=I
" show text as much as possible even if the last line is too long
set display=lastline
" hide mode to disable redraw when leaving submode
" see. help g:submode_always_show_submode
set noshowmode
" }}}

" tabpages {{{
set showtabline=2
set tabline=%!vimrc#tabline()
command! -nargs=? SetTabTitle  call vimrc#set_tabpage_title(<q-args>)
" }}}

" completion {{{
set wildignore&
set wildignore+=.git,.hg,.svn
set wildignore+=*.o,*.exe,*.zip
set wildignore+=.gradle,.m2,*.jar,*.class
set wildignore+=.DS_Store
set nowildmenu
set wildmode=list:longest,full

" use dictionary by default
set complete& complete+=k
" }}}

" /option }}}


" command {{{
" ------------------------------------------------------------------------------

" file encoding & line feed code {{{
command! -bang -bar -complete=file -nargs=? Utf8       edit<bang> ++enc=utf-8       <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp  edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932      edit<bang> ++enc=cp932       <args>
command! -bang -bar -complete=file -nargs=? Euc        edit<bang> ++enc=euc-jp      <args>
command! -bang -bar -complete=file -nargs=? Utf16      edit<bang> ++enc=utf-16le    <args>
command! -bang -bar -complete=file -nargs=? Utf16be    edit<bang> ++enc=utf-16      <args>

command! -bang -bar -complete=file -nargs=? Unix  edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac   edit<bang> ++fileformat=mac  <args>
command! -bang -bar -complete=file -nargs=? Dos   edit<bang> ++fileformat=dos  <args>
" }}}

" remove spaces {{{
command! -range=% TrimSpace  <line1>,<line2>s!\s*$!!g | nohlsearch

command! -range=% ShrinkSpace  <line1>,<line2>s![^ ]\zs\s\+! !g | nohlsearch | normal gv
" }}}

" insert a blank line every N lines
command! -range=% -nargs=1 InsertBlankLineEvery  <line1>,<line2>s!\v(.*\n){<args>}!&\r! | nohlsearch

" remove blank lines
command! -range=% RemoveBlankLines  silent <line1>,<line2>g/^\s*$/d | nohlsearch

" remove trail ^M
command! -range=% RemoveTrailM  <line1>,<line2>s!\r$!!g | nohlsearch

" reload file
command! -nargs=0 Reload  call vimrc#reload_file()

" rename file
command! -nargs=1 -complete=file Rename  call vimrc#rename_file('<args>') | call vimrc#reload_file()

" command CD
command! -nargs=? -complete=dir Cd  call vimrc#cd('<args>')
nnoremap <silent> <Space>cd  :<C-u>Cd<CR>

" format JSON
command! -range=% FormatJson  <line1>,<line2>!python -m json.tool

" capture outputs of command
" ref. http://d.hatena.ne.jp/tyru/20100427/vim_capture_command
command! -nargs=+ -complete=command Capture  call vimrc#cmd_capture(<q-args>)

" draw underline
" ref. http://vim.wikia.com/wiki/Underline_using_dashes_automatically
command! -nargs=? Underline  call vimrc#underline(<q-args>)

" delete buffers without breaking window layout
command! Bdelete  call vimrc#delete_buffer()

" clear quickfix list
command! ClearQuickfix  call setqflist([])

" clear location list
command! ClearLocationList  call setloclist(0, [])

" generate random string
command! RandomString  let @+ = vimrc#random_string(8)

" generate UUID version 4
command! Uuid  let @+ = vimrc#uuid()

" messages
command! ClearMessages  call vimrc#clear_messages()
command! CopyMessages  call vimrc#copy_messages()

" grep and qfreplace
" ex) :Greprep foo src/**/*.vim
command! -nargs=+ -complete=file Greprep  call vimrc#greprep(<q-args>)

" sudo write
command! SudoWrite  write !sudo tee > /dev/null %

" sort lines
command! -bang -range=% SortLines  <line1>,<line2>call vimrc#sort_lines('<bang>')

" urlencode/urldecode
command! -nargs=1 UrlEncode  let @+ = vimrc#urlencode(<q-args>) | echo @+
command! -nargs=1 UrlDecode  let @+ = vimrc#urldecode(<q-args>) | echo @+
" /command }}}


" keymap {{{
" ------------------------------------------------------------------------------

" vimrc {{{
nnoremap <Space>s.  :<C-u>source $MYVIMRC<CR>
nnoremap <Space>.   :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>s>  :<C-u>source $HOME/.gvimrc<CR>
nnoremap <Space>>   :<C-u>edit $HOME/.gvimrc<CR>
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
noremap H  b
noremap L  w
nnoremap Y  y$
nnoremap n  nzz
nnoremap N  Nzz
nnoremap <C-o>  <C-o>zz
nnoremap <C-i>  <C-i>zz
nnoremap ]c  ]czz
nnoremap [c  [czz
nnoremap <C-e>  <C-e>j
nnoremap <C-y>  <C-y>k

nnoremap gm  `[v`]
vnoremap gm  :<C-u>normal gm<CR>
onoremap gm  :<C-u>normal gm<CR>

inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-d>  <Delete>
nnoremap <silent> O  :<C-u>call append(expand('.'), '')<CR>j
nnoremap <Space>M  :<C-u>marks<CR>:mark<Space>

vnoremap <silent> y  y`]
vnoremap <silent> p  p`]
nnoremap <silent> p  p`]

" paste yank register
nnoremap zp  "0p`]
vnoremap zp  "0p`]
nnoremap zP  "0P`]
vnoremap zP  "0P`]

vnoremap <C-h>  ^
vnoremap <C-l>  $

" don't quit vim
nnoremap ZQ <Nop>
" }}}

" copy(yank) and paste with clipboard {{{
if s:nix
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
cnoremap <C-b>  <Left>

" remove last element if a string in command line is like path string {{{
cnoremap <C-w>  <C-\>evimrc#remove_path_element()<CR>

cnoremap <expr> <CR>  (vimrc#help_with_trailing_atmark()) ? "en\<CR>" : "\<CR>"
" }}}

" }}}

" toggle option {{{
nnoremap <silent> <Space>ow  :<C-u>call vimrc#toggle_option('wrap')<CR>
nnoremap <silent> <Space>nu  :<C-u>call vimrc#toggle_option('number')<CR>
nnoremap <silent> <Space>et  :<C-u>call vimrc#toggle_option('expandtab')<CR>
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
onoremap aq  2i'
vnoremap aq  2i'
onoremap iq  i'
vnoremap iq  i'

onoremap a'  2i'
vnoremap a'  2i'

" "double quote"
onoremap ad  2i"
vnoremap ad  2i"
onoremap id  i"
vnoremap id  i"

onoremap a"  2i"
vnoremap a"  2i"

" backquote
onoremap a`  2i`
vnoremap a`  2i`

" textobj-between (default f)
let g:textobj_between_no_default_key_mappings = 1
omap a;  <Plug>(textobj-between-a)
omap i;  <Plug>(textobj-between-i)
vmap a;  <Plug>(textobj-between-a)
vmap i;  <Plug>(textobj-between-i)
" }}}

" handle window {{{
" key repeat for window sizing ( <C-w>+++ = <C-w>+<C-w>+<C-w>+ )
" XXX this can be replaced with vim-submode
nmap <C-w>+  <C-w>+<SID>(window-size)
nmap <C-w>-  <C-w>-<SID>(window-size)
nmap <C-w>>  <C-w>><SID>(window-size)
nmap <C-w><  <C-w><<SID>(window-size)
nnoremap <script> <SID>(window-size)+  <C-w>+<SID>(window-size)
nnoremap <script> <SID>(window-size)-  <C-w>-<SID>(window-size)
nnoremap <script> <SID>(window-size)>  <C-w>><SID>(window-size)
nnoremap <script> <SID>(window-size)<  <C-w><<SID>(window-size)
nmap <SID>(window-size)  <Nop>

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

nnoremap <C-n>   <C-w>w
nnoremap <C-p>   <C-w>W
" }}}

" yank filename {{{
if s:mac
	nnoremap <silent> <Space>yf  :let @*=expand('%:p')<CR>
	nnoremap <silent> <Space>yy  :let @*=expand('%')<CR>
else
	nnoremap <silent> <Space>yf  :let @+=expand('%:p')<CR>
	nnoremap <silent> <Space>yy  :let @+=expand('%')<CR>
endif
" }}}

" quickfix {{{
nnoremap [Quickfix]  <Nop>
nmap q  [Quickfix]
nnoremap Q  q

nnoremap <silent> [Quickfix]n   :<C-u>cnext<CR>
nnoremap <silent> [Quickfix]p   :<C-u>cprevious<CR>
nnoremap <silent> [Quickfix]j   :<C-u>cnext<CR>
nnoremap <silent> [Quickfix]k   :<C-u>cprevious<CR>
nnoremap <silent> [Quickfix]r   :<C-u>crewind<CR>
nnoremap <silent> [Quickfix]N   :<C-u>cfirst<CR>
nnoremap <silent> [Quickfix]P   :<C-u>clast<CR>
nnoremap <silent> [Quickfix]fn  :<C-u>cnfile<CR>
nnoremap <silent> [Quickfix]fp  :<C-u>cpfile<CR>
nnoremap <silent> [Quickfix]l   :<C-u>clist<CR>
nnoremap <silent> [Quickfix]q   :<C-u>cc<CR>
nnoremap <silent> [Quickfix]o   :<C-u>copen<CR>
nnoremap <silent> [Quickfix]c   :<C-u>cclose<CR>
nnoremap <silent> [Quickfix]en  :<C-u>cnewer<CR>
nnoremap <silent> [Quickfix]ep  :<C-u>colder<CR>
nnoremap <silent> [Quickfix]m   :<C-u>make<CR>
" }}}

" misc {{{
nnoremap <silent> *
\	:<C-u>call vimrc#search_without_move()<CR>zz:<C-u>set hlsearch<CR>

" search with the selected text
vnoremap <silent> *
\	:<C-u>call vimrc#search_with_selected_text()<CR>zz:<C-u>set hlsearch<CR>
vnoremap <silent> <CR>
\	:<C-u>call vimrc#search_with_selected_text()<CR>zz:<C-u>set hlsearch<CR>

" identify the syntax highlighting group used at the cursor
command! ShowHilite  call vimrc#show_hilite()
nnoremap <C-F12>  :<C-u>ShowHilite<CR>

" hlsearch (search and highlight)
nnoremap <Esc><Esc>  :<C-u>nohlsearch<CR>

" completion
inoremap <expr> <CR>  pumvisible() ? "\<C-y>" : "\<CR>"

nnoremap <C-]>  g<C-]>

" paste and increment and yank
nnoremap <F4>  "0P<C-a>yy
nnoremap <S-F4>  "0p<C-a>yy

" complete by dictionary
inoremap <C-k>  <C-x><C-k>
" }}}

" abbrev {{{
inoreabbrev filed  field
" }}}

" /keymap }}}


" plugin {{{
" ------------------------------------------------------------------------------

" unite {{{

" option {{{
let g:unite_split_rule = 'aboveleft'
let g:unite_update_time = 100
let g:unite_data_directory = vimrc#dir(vimrc#tmp_dir . '/unite/data')
" }}}

" keymap {{{
nnoremap <Space><Space>  :<C-u>Unite<Space>
nnoremap <silent> <Space>f  :<C-u>Unite buffer_tab file_mru file<CR>
nnoremap <silent> <Space>b  :<C-u>Unite buffer_tab<CR>
" }}}


" change default behavior {{{
call unite#custom#default_action('buffer_tab', 'goto')
call unite#custom#default_action('buffer', 'goto')

call unite#custom#profile('default', 'context', {
\	'no_split': 1,
\	'no_empty': 1,
\})

call unite#custom#profile('source/grep', 'context', {
\	'no_quit': 1,
\	'keep_focus': 1,
\	'auto_preview': 1,
\})

" ignore_pattern {{{
let s:ignore_pattern = '\M' . join([
\	'/bak/',
\	'/build/',
\	'/.git/',
\	'/.hg/',
\	'/.svn/',
\	'/.gradle/',
\	'/.m2/',
\	'.DS_Store$',
\	'.o$',
\	'.exe$',
\	'.zip$',
\	'.class$',
\	'.jar$',
\], '\|')

call unite#custom#source('file_rec', 'ignore_pattern', s:ignore_pattern)
call unite#custom#source('file_rec/async', 'ignore_pattern', s:ignore_pattern)
call unite#custom#source('find', 'ignore_pattern', s:ignore_pattern)

unlet s:ignore_pattern
" }}}

" shorten path {{{
call unite#define_filter({
\	'name': 'converter_short_path',
\	'filter': function('vimrc#unite_converter_short_path'),
\})

call unite#custom#source('file_mru', 'converters', ['converter_short_path'])
call unite#custom#source('file_rec', 'converters', ['converter_short_path'])
" }}}

" }}}

let g:unite_source_buffer_time_format = '(%H:%M) '

" unite alias {{{
let g:unite_source_alias_aliases = {
\	'vim' : {
\		'source': 'file_rec/async',
\		'args': expand('~/.vim'),
\	},
\	'sandbox' : {
\		'source': 'file_rec/async',
\		'args': expand('~/src/github.com/scheakur/sandbox'),
\	},
\	'keymap' : {
\		'source': 'output',
\		'args': join(['map', 'map!', 'lmap'], '|'),
\	},
\ }
" }}}

let g:unite_source_grep_max_candidates = 100

command! -nargs=* -complete=dir Grep  call vimrc#unite_grep(<f-args>)

" initialize unite menu
let g:unite_source_menu_menus = {}

let g:unite_source_menu_menus.vim = {
\	'description': 'Vim'
\}

let g:unite_source_menu_menus.vim.command_candidates = [
\	['Diff on these two', 'diffthis | wincmd p | diffthis'],
\	['Diff off these two', 'diffoff | wincmd p | diffoff'],
\	['Diff against original file', 'vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis'],
\]

" /unite }}}

" vimfiler {{{
let g:vimfiler_tree_leaf_icon = ''
let g:vimfiler_tree_indentation = 2
call vimfiler#custom#profile('default', 'context', {
\	'split': 1,
\	'winwidth': 48,
\	'create': 1,
\	'force_quit': 1,
\	'explorer': 1,
\})

nnoremap <expr> <Leader>f  ':VimFiler ' . expand('%:h') . "\<CR>"
" }}}

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
\		'hook/repautocd_pause/enable': 1,
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
\		'args': '%{vimrc#get_oracle_conn("quickrun")}',
\		'tempfile': '%{tempname()}.sql',
\		'exec': '%c %o %a \@%s',
\		'outputter/buffer/filetype': 'quickrun.sqloutput',
\	},
\	'rst': {
\		'command': 'pandoc',
\		'outputter': 'browser',
\	},
\	'markdown': vimrc#quickrun_config_for_markdown('nice.css'),
\	'presen': vimrc#quickrun_config_for_markdown('presentation.css'),
\}

if s:mac
	call extend(g:quickrun_config, {
	\	'markdown': {
	\		'command': 'open',
	\		'cmdopt': '-a',
	\		'tempfile': '%{tempname()}.md',
	\		'exec': '%c %s %o /Applications/Marked\ 2.app',
	\		'outputter': 'null',
	\	},
	\})
endif

nnoremap <expr><silent> <C-c>  quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
" }}}

" watchdogs {{{
let g:watchdogs_check_BufWritePost_enables = {
\	'javascript': 1,
\}

call extend(g:quickrun_config, {
\	'javascript/watchdogs_checker': {
\		'type': executable('eslint') ? 'watchdogs_checker/eslint' : ''
\	},
\})
" }}}

" dois.vim {{{
let g:dois_file = expand('~/Dropbox/tmp/doinglist.taskpaper')
let g:dois_dir = expand('~/Dropbox/tmp/doinglist')
nmap <C-CR>  <Plug>(dois:n:add-daily-task)
" }}}

" operator-replace {{{
call operator#user#define('my-replace', 'vimrc#operator_replace_do')

nmap s  <Plug>(operator-my-replace)
nmap S  <Plug>(operator-my-replace)$
nmap ss  <Plug>(operator-my-replace)<Plug>(textobj-line-a)
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
\	'md',
\	'js',
\	'rb',
\	'txt',
\	'vim',
\	'sql',
\	'xml',
\	'html',
\	'css',
\	'go',
\	'groovy',
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
inoremap <C-Tab>  <C-x><C-u>
inoremap <expr> <S-Tab>  pumvisible() ? "\<C-p>" : "\<S-Tab>"

imap <expr> <Tab>
\	neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
\	pumvisible() ? "\<C-n>" :
\	"\<Tab>"

smap <expr> <Tab>
\	neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" :
\	"\<Tab>"

xmap <Tab>  <Plug>(neosnippet_expand_target)
" }}}

" operator-camerize {{{
map <Leader>c  <Plug>(operator-camelize-toggle)
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

" operator-siege {{{
let g:operator_siege_decos = [
\	{'chars': [' ', ' '], 'keys': [' ']},
\	{'chars': ['/', '/'], 'keys': ['/']},
\	{'chars': ['=', '='], 'keys': ['=']},
\	{'chars': ['#', '#'], 'keys': ['#']},
\	{'chars': ['「', '」'], 'keys': ['d']},
\]

call vimrc#define_operator_my_siege_add()
map sa  <Plug>(operator-my-siege-add)

call vimrc#define_operator_my_siege_change()
nmap sc  <Plug>(operator-my-siege-change)

nmap sd  <Plug>(operator-siege-delete)
" }}}

" vim-repautocd {{{
let g:repautocd_markers = [
\	'.git',
\	'.hg',
\	'.svn',
\	'.gitignore',
\	'.project',
\	'.idea',
\	'package.json',
\	'Gemfile',
\]
" }}}

" sonictemplate-vim {{{
let g:sonictemplate_vim_template_dir = [
\	expand('~/.vim/template'),
\	expand('~/.vim.local/template'),
\]

let g:sonictemplate_key = '<SID>(disable)'
let g:sonictemplate_intelligent_key = '<SID>(disable)'

inoremap <C-e>  <Esc>:call vimrc#apply_template()<CR>i
" }}}

" vim-submode {{{
let g:submode_keep_leaving_key = 1

" fold
call submode#enter_with('foldopen', 'n', '', 'zo', 'zo')
call submode#map('foldopen', 'n', '', 'o', 'zjzozz')
call submode#map('foldopen', 'n', '', 'u', 'zkzczz')

call submode#enter_with('foldclose', 'n', '', 'zc', 'zc')
call submode#map('foldclose', 'n', '', 'c', 'zjzczz')
call submode#map('foldclose', 'n', '', 'u', 'zkzozz')

" change tab
call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
call submode#map('changetab', 'n', '', 't', 'gt')
call submode#map('changetab', 'n', '', 'T', 'gT')

" window
call submode#enter_with('wincycle', 'n', '', '<C-w><C-w>', '<C-w>w')
call submode#enter_with('wincycle', 'n', '', '<C-w>w', '<C-w>w')
call submode#map('wincycle', 'n', '', '<C-w>', '<C-w>w')
call submode#map('wincycle', 'n', '', 'w', '<C-w>w')
" }}}

" vim-operator-jump_side {{{
nmap <Space>h <Plug>(operator-jump-head-out)
nmap <Space>l <Plug>(operator-jump-tail-out)
nmap <Space>H <Plug>(operator-jump-head)
nmap <Space>L <Plug>(operator-jump-tail)
" }}}

" vim-expand-region {{{
vmap v  <Plug>(expand_region_expand)
vmap <C-v>  <Plug>(expand_region_shrink)

let g:expand_region_text_objects = {
\	'i;/': 0,
\	'a;/': 0,
\	'i]' : 1,
\	'a]' : 1,
\	'i)' : 1,
\	'a)' : 1,
\	'i}' : 1,
\	'a}' : 1,
\	'il' : 0,
\	'al' : 0,
\}
" }}}

" agit {{{
let g:agit_no_default_mappings = 1
let g:agit_enable_auto_show_commit = 0
" }}}

" /plugin }}}


" autocmd {{{
" ------------------------------------------------------------------------------

" create non-existing diretories automatically when the file is saved
autocmd vimrc BufWritePre *  call vimrc#mkdir(expand('<afile>:p:h'))

" open quickfix window after executing make
autocmd vimrc QuickfixCmdPost  make copen

" avoid saving files with keyboard misstroke
" ref. http://d.hatena.ne.jp/tyru/20130419/avoid_tyop
autocmd vimrc BufWriteCmd *;*  call vimrc#ignore_invalid_file(expand('<afile>'))

" reload a file on WinEnter if the file has been modified
set autoread
autocmd vimrc WinEnter *  checktime

" key mapping in vimdiff
autocmd vimrc FilterWritePre *  call vimrc#config_in_diff_mode()

" maximize help window
autocmd vimrc BufWinEnter *  call vimrc#maximize_winheight_in_help()

" select readonly as swapchoice automatically
autocmd vimrc SwapExists *  let v:swapchoice = 'o'

" select reload as fcs_choice automatically
autocmd vimrc FileChangedShell *  let v:fcs_choice = 'reload'
" }}}


" finally {{{
" ------------------------------------------------------------------------------

call vimrc#load_local_vimrc()
call watchdogs#setup(g:quickrun_config)
call vimrc#print_error_in_splash()
set secure

" /finally }}}


" @see :help modeline
" vim: noexpandtab
" vim: foldenable foldmethod=marker
" vim: formatoptions& formatoptions-=ro
