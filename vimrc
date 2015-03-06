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
let s:in_mac = has('mac') || has('macunix')
let s:in_nix = !s:in_mac && has('unix')
" }}}

if !s:in_mac
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
let &directory = expand('~/tmp/vim,') . &directory
set undofile
call vimrc#mkdir(expand('~/tmp/vim/undo'))
let &undodir = expand('~/tmp/vim/undo,') . &directory
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
" hide intro message
set shortmess+=I
" show text as much as possible even if the last line is too long
set display=lastline
" }}}

" tabpages {{{
set showtabline=2
set tabline=%!vimrc#tabline()
command! -nargs=? SetTabTitle  call vimrc#set_tabpage_title(<q-args>)
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
command! -bang -bar -complete=file -nargs=? Utf8       edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp  edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932      edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc        edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16      edit<bang> ++enc=utf-16le <args>
command! -bang -bar -complete=file -nargs=? Utf16be    edit<bang> ++enc=utf-16 <args>

command! -bang -bar -complete=file -nargs=? Unix  edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac   edit<bang> ++fileformat=mac <args>
command! -bang -bar -complete=file -nargs=? Dos   edit<bang> ++fileformat=dos <args>
" }}}

" remove spaces {{{
command! -range=% TrimSpace  <line1>,<line2>s!\s*$!!g | nohlsearch

command! -range ShrinkSpace  <line1>,<line2>s![^ ]\zs\s\+! !g | nohlsearch | normal gv
" }}}

" insert a blank line every N lines {{{
command! -range -nargs=1 InsertBlankLineEvery  <line1>,<line2>s!\v(.*\n){<args>}!&\r! | nohlsearch
" }}}

" rename file
command! -nargs=1 -complete=file Rename  f <args>|w|call delete(expand('#'))

" remove trail ^M
command! -range=% RemoveTrailM  <line1>,<line2>s!\r$!!g | nohlsearch

" command CD
command! -nargs=? -complete=dir -bang CD  call vimrc#cd('<args>', '<bang>')
nnoremap <silent> <Space>cd  :<C-u>CD<CR>

" format JSON
command! -range FormatJson  <line1>,<line2>!python -m json.tool

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
command! UUID  let @+ = vimrc#uuid()

" messages
command! ClearMessages  call vimrc#clear_messages()
command! CopyMessages  call vimrc#copy_messages()

" grep and qfreplace
command! -nargs=+ -complete=file Greprep  call vimrc#greprep(<q-args>)

" sudo write
command! SudoWrite  w !sudo tee > /dev/null %

" /command }}}


" keymap {{{
" ------------------------------------------------------------------------------

" vimrc {{{
nnoremap <Space>s.  :<C-u>source $MYVIMRC<CR>
nnoremap <Space>.   :<C-u>edit   $MYVIMRC<CR>
nnoremap <Space>s>  :<C-u>source $HOME/.gvimrc<CR>
nnoremap <Space>>   :<C-u>edit   $HOME/.gvimrc<CR>
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

" paste yank register
nnoremap zp  "0p
vnoremap zp  "0p
nnoremap zP  "0P
vnoremap zP  "0P
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

" remove last element if a string in command line is like path string {{{
cnoremap <C-w>  <C-\>evimrc#remove_path_element()<CR>

cnoremap <expr> <CR>  (vimrc#help_with_trailing_atmark()) ? "en\<CR>" : "\<CR>"
" }}}

" }}}

" toggle option {{{
nnoremap <silent> <Space>ow  :<C-u>call vimrc#toggle_option('wrap')<CR>
nnoremap <silent> <Space>nu  :<C-u>call vimrc#toggle_option('number')<CR>
nnoremap <silent> <Space>hl  :<C-u>call vimrc#toggle_option('hlsearch')<CR>
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
" key repeat for window sizing ( <C-w>+++ = <C-w>+<C-w>+<C-w>+ )
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
" }}}

" yank filename {{{
if s:in_mac
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
nnoremap <F8>  P<C-a>yy
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


" change default behavior {{{
call unite#custom#default_action('buffer_tab', 'goto')
call unite#custom#default_action('buffer', 'goto')

call unite#custom#profile('default', 'context', {
\	'no_split': 1
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

" highlight for status line of unite
highlight link uniteStatusHead uniteStatusNormal
highlight link uniteStatusLineNR uniteStatusNormal
highlight link uniteStatusMessage uniteStatusNormal
highlight link uniteStatusSourceCandidates uniteStatusNormal
highlight link uniteStatusSourceNames uniteStatusNormal

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
\	'javascript.es6' : {
\		'tempfile': '%{tempname()}.js',
\		'exec': 'iojs --harmony %s',
\	},
\}

if s:in_mac
	call extend(g:quickrun_config, {
	\	'markdown' : {
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
" }}}

" dois.vim {{{
let g:dois_file = expand('~/Dropbox/tmp/doinglist.taskpaper')
let g:dois_dir = expand('~/Dropbox/tmp/doinglist')
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

" operator-surround {{{
map <silent> <Leader>sy  <Plug>(operator-surround-append)
map <silent> <Leader>sd  <Plug>(operator-surround-delete)
map <silent> <Leader>sc  <Plug>(operator-surround-replace)
" }}}

" vim-repautocd {{{
let g:repautocd_markers = [
\	'.git',
\	'.hg',
\	'.svn',
\	'.gitignore',
\	'.project',
\	'package.json',
\]
" }}}

" sonictemplate-vim {{{
let g:sonictemplate_vim_template_dir = expand('~/.vim.local/template')

inoremap <C-e>  <Esc>diw:Template<Space><C-r>-<C-l><CR>i
" }}}

" vim-submode {{{
let g:submode_keep_leaving_key = 1

" fold
call submode#enter_with('foldopen', 'n', '', 'zo', 'zozj')
call submode#map('foldopen', 'n', '', 'o', 'zozj')
call submode#enter_with('foldclose', 'n', '', 'zc', 'zczj')
call submode#map('foldclose', 'n', '', 'c', 'zczj')

" change tab
call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
call submode#map('changetab', 'n', '', 't', 'gt')
call submode#map('changetab', 'n', '', 'T', 'gT')
" }}}

" /plugin }}}


" autocmd {{{
" ------------------------------------------------------------------------------

" Create non-existing diretories automatically when the file is saved.
autocmd vimrc BufWritePre *  call vimrc#mkdir(expand('<afile>:p:h'))

" Open quickfix window after executing make.
autocmd vimrc QuickfixCmdPost  make copen

" Avoid saving files with keyboard misstroke
" ref. http://d.hatena.ne.jp/tyru/20130419/avoid_tyop
autocmd vimrc BufWriteCmd *;*  call vimrc#ignore_invalid_file(expand('<afile>'))

" Reload a file on WinEnter if the file has been modified
set autoread
autocmd vimrc WinEnter *  checktime

" key mapping in vimdiff
autocmd vimrc FilterWritePre *  call vimrc#config_in_diff_mode()

" Maximize help window
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
" vim: set noexpandtab :
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
