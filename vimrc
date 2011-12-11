" ========================================================================
"     vimrc
" ========================================================================

" basic {{{
" ------------------------------------------------------------------------
scriptencoding utf-8
" disable vi compatible mode
set nocompatible

" clear command
augroup my
    autocmd!
augroup end

" user interface in English
language messages C
language time C

function! s:load_local_vimrc(...)
    let l:suffix = (a:0 > 0) ? ('.' . a:1) : ''
    let l:vimrc = expand('~/.vimrc.local' . l:suffix)
    if filereadable(l:vimrc)
        try
            execute 'source' l:vimrc
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

syntax enable

" runtimepath {{{
filetype off

" vundle {{{
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
" vundle itself
Bundle 'git://github.com/gmarik/vundle.git'

" vundle list {{{
Bundle 'git://github.com/h1mesuke/ref-dicts-en.git'
Bundle 'git://github.com/kana/vim-smartchr.git'
Bundle 'git://github.com/pangloss/vim-javascript.git'
Bundle 'git://github.com/scheakur/dois.vim.git'
Bundle 'git://github.com/scheakur/scheakur.vim.git'
Bundle 'git://github.com/Shougo/neocomplcache.git'
Bundle 'git://github.com/Shougo/vimfiler.git'
Bundle 'git://github.com/Shougo/vimproc.git'
Bundle 'git://github.com/Shougo/unite.vim.git'
Bundle 'git://github.com/t9md/vim-quickhl.git'
Bundle 'git://github.com/thinca/vim-ambicmd.git'
Bundle 'git://github.com/thinca/vim-quickrun.git'
Bundle 'git://github.com/thinca/vim-ref.git'
Bundle 'git://github.com/thinca/vim-rtputil.git'
Bundle 'git://github.com/tyru/caw.vim.git'
Bundle 'git://github.com/ujihisa/neco-look.git'
Bundle 'git://github.com/vim-jp/vimdoc-ja.git'
Bundle 'git://github.com/vim-scripts/groovyindent'
Bundle 'git://github.com/vim-scripts/newspaper.vim.git'
Bundle 'git://github.com/vim-scripts/Lucius.git'
Bundle 'git://github.com/vim-scripts/sudo.vim.git'
" }}}

" }}}

" rptutil {{{
call rtputil#bundle('try')
call rtputil#helptags()
" }}}

" after bundling, enable filetype
filetype plugin on
filetype indent on
" /runtimepath }}}


" color {{{
" auto loading after/colors {{{
function! s:load_after_colors()
    let l:color = expand('~/.vim/after/colors/' . g:colors_name . '.vim')
    if filereadable(l:color)
        execute 'source' l:color
    endif
endfunction
autocmd my ColorScheme * call s:load_after_colors()
" }}}
colorscheme lucius
" }}}

" /basic }}}


" option {{{
" ------------------------------------------------------------------------

" search {{{
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
" }}}

" encoding & file {{{
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
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
" }}}

" invisible characters {{{
set list
set listchars=tab:>-,trail:･
" }}}

" footer (statusline, cmdheight) {{{
set laststatus=2
set statusline=%<@%{getcwd()}\|%f\ %y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%m%r%h%w%=%lL\ %2vC\ %3p%%
set cmdheight=2
" }}}

" misc {{{
set autoread
set hidden
set backspace=indent,eol,start
set clipboard& clipboard+=unnamed
set modeline
" Do not increase/decrease as octal number or hexadecimal number
set nrformats& nrformats-=octal,hex
set virtualedit=block
set formatoptions=tcroqnlM1
" show the number of lines of selection
set showcmd
" }}}

" tabline {{{
set showtabline=2
set tabline=%!MyMakeTabLine()

function! MyMakeTabLine()
    let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
    let tabpages = join(titles, '') . ' ' . '%#TabLineFill#%T'
    let info = fnamemodify(getcwd(), ":~") . ' '
    return tabpages . '%=' . info
endfunction

function! s:tabpage_label(n)
    let title = gettabvar(a:n, 'title')
    if title !=# ''
        return title
    endif
    let bufnrs = tabpagebuflist(a:n)
    let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'
    let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '*' : ''
    let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]
    let fname = pathshorten(bufname(curbufnr))
    if fname ==# ''
        let fname = '[No Name]'
    endif
    let label = ' ' . fname . mod . ' '
    return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction
" }}}

" completion {{{
set wildignore& wildignore+=.git,.svn,*.class
set nowildmenu
set wildmode=list:longest,full
" }}}

" /option }}}


" command {{{
" ------------------------------------------------------------------------

" file encoding & line feed code {{{
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>

command! -bang -bar -complete=file -nargs=? Unix edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac edit<bang> ++fileformat=mac <args>
command! -bang -bar -complete=file -nargs=? Dos edit<bang> ++fileformat=dos <args>
" }}}

" remove spaces {{{
command! -range=% TrimSpace :setlocal nohlsearch | :<line1>,<line2>s!\s*$!!g
command! -range ShrinkSpace
            \ :setlocal nohlsearch
            \ | :<line1>,<line2>s!\s\{2,}! !g
            \ | :normal gv
" }}}

" junk file {{{
" ref. http://vim-users.jp/2010/11/hack181/
command! -nargs=0 Junk call s:open_junk_file('txt', 0)
command! -nargs=0 Junkfile call s:open_junk_file('', 0)
command! -nargs=0 Junkjs call s:open_junk_file('js', 1)
command! -nargs=0 Junkhtml call s:open_junk_file('html', 1)
command! -nargs=0 Junktext call s:open_junk_file('txt', 1)
command! -nargs=0 Junksql call s:open_junk_file('sql', 1)
function! s:open_junk_file(ext, immediately)
    let l:junk_dir = $HOME . '/tmp/junk'. strftime('/%Y/%m')
    if !isdirectory(l:junk_dir)
        call mkdir(l:junk_dir, 'p')
    endif

    let l:filename = l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.') . a:ext
    if !a:immediately
        let l:filename = input('Junk File: ', l:filename)
    endif

    if l:filename != ''
        execute 'edit ' . l:filename
    endif
endfunction
"}}}

" insert a blank line every N lines {{{
command! -range -nargs=1  InsertBlankLineEvery
            \ :setlocal nohlsearch
            \ | :<line1>,<line2>s!\v(.*\n){<args>}!&\r
" }}}

" rename file
command! -nargs=1 -complete=file Rename f <args>|w|call delete(expand('#'))

" remove trail ^M
command! -range RemoveTrailM :setlocal nohlsearch | :<line1>,<line2>s!\r$!!g


" change current directory {{{
" command CD {{{
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif
    if a:bang == ''
        pwd
    endif
endfunction
" }}}
nnoremap <silent> <Space>cd :<C-u>CD<Return>
" }}}

" capture outputs of command {{{
" ref. http://d.hatena.ne.jp/tyru/20100427/vim_capture_command
command!
\   -nargs=+ -complete=command
\   Capture
\   call s:cmd_capture(<q-args>)

function! s:cmd_capture(q_args) "{{{
    redir => output
    silent execute a:q_args
    redir END
    let output = substitute(output, '^\n\+', '', '')

    belowright new

    silent file `=printf('[Capture: %s]', a:q_args)`
    setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
    call setline(1, split(output, '\n'))
endfunction "}}}
" }}}

" /command }}}


" keymap {{{
" ------------------------------------------------------------------------

" map leader {{{
let mapleader = ','
let maplocalleader = '\'
" }}}

" vimrc {{{
nnoremap <Space>s.  :<C-u>source $MYVIMRC<Return>
nnoremap <Space>.  :<C-u>edit $MYVIMRC<Return>
nnoremap <Space>s>  :<C-u>source ~/.gvimrc<Return>
nnoremap <Space>>  :<C-u>edit ~/.gvimrc<Return>
" }}}

" basic {{{
noremap ;  :
noremap :  ;
noremap '  `
noremap `  '
nnoremap j  gj
nnoremap k  gk
nnoremap gj  j
nnoremap gk  k
vnoremap j  gj
vnoremap k  gk
vnoremap gj  j
vnoremap gk  k
nnoremap Y  y$
vnoremap <  <gv
vnoremap >  >gv
nnoremap n  nzz
nnoremap N  Nzz
nnoremap e  W
nnoremap E  B
vnoremap e  W
vnoremap E  B

inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-d>  <Delete>
nnoremap <expr> s*  ':%s/\<' . expand('<cword>') . '\>//g<Left><Left>'
nnoremap O  :<C-u>call append(expand('.'), '')<Return>j
nnoremap <Space>M  :<C-u>marks<Return>:mark<Space>
" }}}

" copy(yank) and paste with clipboard {{{
if s:in_nix
    inoremap <C-o>p  <C-r><C-o>+
    cnoremap <C-o>p  <C-r><C-o>+
    nnoremap <C-o>p  "+p
    nnoremap <C-o>P  "+P
    vnoremap <C-o>y  "+y
    vnoremap <C-o>Y  "+y$
    nnoremap <C-o>y  "+y
    nnoremap <C-o>Y  "+y$
else
    inoremap <C-o>p  <C-r><C-o>*
    cnoremap <C-o>p  <C-r><C-o>*
    nnoremap <C-o>p  "*p
    nnoremap <C-o>P  "*P
    vnoremap <C-o>y  "*y
    vnoremap <C-o>Y  "*y$
    nnoremap <C-o>y  "*y
    nnoremap <C-o>Y  "*y$
endif
" }}}

" command line mode {{{
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-l> <Right>
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'
cnoremap <C-p>  <Up>
cnoremap <Up>  <C-p>
cnoremap <C-n>  <Down>
cnoremap <Down>  <C-n>
" }}}

" toggle option {{{
function! s:ToggleOption(option_name)
    execute 'setlocal ' . a:option_name . '!'
    execute 'setlocal ' . a:option_name . '?'
endfunction
nnoremap <silent> <Space>ow  :<C-u>call <SID>ToggleOption('wrap')<Return>
nnoremap <silent> <Space>nu  :<C-u>call <SID>ToggleOption('number')<Return>
nnoremap <silent> <Space>hl  :<C-u>call <SID>ToggleOption('hlsearch')<Return>
nnoremap <silent> <Space>et  :<C-u>call <SID>ToggleOption('expandtab')<Return>
" }}}

" current date/time {{{
inoremap <Leader>dF <C-r>=strftime('%Y-%m-%dT%H:%M:%S%z')<Return>
inoremap <Leader>df <C-r>=strftime('%Y-%m-%d %H:%M:%S')<Return>
inoremap <Leader>dd <C-r>=strftime('%Y-%m-%d')<Return>
inoremap <Leader>dm <C-r>=strftime('%Y-%m')<Return>
inoremap <Leader>dy <C-r>=strftime('%Y')<Return>
inoremap <Leader>dT <C-r>=strftime('%H:%M:%S')<Return>
inoremap <Leader>dt <C-r>=strftime

cnoremap <expr> <C-o>d  strftime('%Y-%m-%d')
cnoremap <expr> <C-o>t  strftime('%Y-%m-%d-%H%M%S')
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
" }}}

" handle window {{{
nnoremap [Window]  <Nop>
nmap w  [Window]
nnoremap [Window]c  <C-w>c
nnoremap [Window]q  <C-w>c
nnoremap [Window]n  <C-w>n
nnoremap [Window]v  <C-w>v
nnoremap [Window]h  <C-w>h
nnoremap [Window]j  <C-w>j
nnoremap [Window]k  <C-w>k
nnoremap [Window]l  <C-w>l
nnoremap [Window]=  <C-w>3+
nnoremap [Window]-  <C-w>3-
nnoremap [Window].  <C-w>3>
nnoremap [Window],  <C-w>3<
nnoremap [Window]_  <C-w>_
nnoremap [Window]+  <C-w>=

" split window
nmap [Window]sj <SID>(split-to-j)
nmap [Window]sk <SID>(split-to-k)
nmap [Window]sh <SID>(split-to-h)
nmap [Window]sl <SID>(split-to-l)
nmap <Space>wj <SID>(split-to-j)
nmap <Space>wk <SID>(split-to-k)
nmap <Space>wh <SID>(split-to-h)
nmap <Space>wl <SID>(split-to-l)

nnoremap <silent> <SID>(split-to-j)  :<C-u>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<Return>
nnoremap <silent> <SID>(split-to-k)  :<C-u>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<Return>
nnoremap <silent> <SID>(split-to-h)  :<C-u>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<Return>
nnoremap <silent> <SID>(split-to-l)  :<C-u>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<Return>
" }}}

" handle tabs and tags {{{
nnoremap [TabTag]  <Nop>
nmap <C-t>  [TabTag]
nnoremap [TabTag]<C-t>  <C-]>
nnoremap [TabTag]<C-j>  :<C-u>tag<Return>
nnoremap [TabTag]<C-k>  :<C-u>pop<Return>
nnoremap [TabTag]<C-n> :<C-u>tabnew<Return>
nnoremap [TabTag]<C-h> :<C-u>tabprevious<Return>
nnoremap [TabTag]<C-l> :<C-u>tabnext<Return>
nnoremap [TabTag]<C-w> :<C-u>tabclose<Return>
" }}}

" yank filename {{{
if s:in_mac
    nnoremap <silent> <Space>yf  :let @*=expand("%:p")<Return>
    nnoremap <silent> <Space>yy  :let @*=expand("%")<Return>
else
    nnoremap <silent> <Space>yf  :let @@=expand("%:p")<Return>
    nnoremap <silent> <Space>yy  :let @@=expand("%")<Return>
endif
" }}}

" quickfix {{{
nnoremap [Quickfix]  <Nop>
nmap q  [Quickfix]
nnoremap Q  q

nnoremap <silent> [Quickfix]n  :<C-u>cnext<CR>
nnoremap <silent> [Quickfix]p  :<C-u>cprevious<CR>
nnoremap <silent> [Quickfix]r  :<C-u>crewind<CR>
nnoremap <silent> [Quickfix]N  :<C-u>cfirst<CR>
nnoremap <silent> [Quickfix]P  :<C-u>clast<CR>
nnoremap <silent> [Quickfix]fn  :<C-u>cnfile<CR>
nnoremap <silent> [Quickfix]fp  :<C-u>cpfile<CR>
nnoremap <silent> [Quickfix]l  :<C-u>clist<CR>
nnoremap <silent> [Quickfix]q  :<C-u>cc<CR>
nnoremap <silent> [Quickfix]o  :<C-u>copen<CR>
nnoremap <silent> [Quickfix]c  :<C-u>cclose<CR>
nnoremap <silent> [Quickfix]en :<C-u>cnewer<CR>
nnoremap <silent> [Quickfix]ep :<C-u>colder<CR>
nnoremap <silent> [Quickfix]m  :<C-u>make<CR>
" }}}

" misc {{{
" search with the selected text
" ref. http://vim-users.jp/2009/11/hack104/
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<Return><Return>
vnoremap <silent> <Return> "vy/\V<C-r>=substitute(escape(@v,'\/'),"\n",'\\n','g')<Return><Return>

" identify the syntax highlighting group used at the cursor
" http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
function! s:show_hilite()
    let hilite = ''
    let hilite .= 'hilite <' . synIDattr(synID(line('.'), col('.'), 1), 'name') . '>, '
    let hilite .= 'trans <' . synIDattr(synID(line('.'), col('.'), 0), 'name') . '>, '
    let hilite .= 'link <' . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . '>'
    echo hilite
endfunction
nnoremap <C-H> :call <SID>show_hilite()<CR>

" till before parenthesis
" ref. http://vim-users.jp/2011/04/hack214/
onoremap )  t)
onoremap (  t(
vnoremap )  t)
vnoremap (  t(
" }}}

" open current file in web browser {{{
if s:in_nix
    " I'm sorry for not using Opera.
    nnoremap <silent> <Space>o :!google-chrome %<Return><Return>
elseif s:in_mac
    nnoremap <silent> <Space>o :!open %<Return><Return>
endif
" }}}

" /keymap }}}


" plugin {{{

" unite {{{

" option {{{
let g:unite_split_rule = 'aboveleft'
" }}}

" keymap {{{
nnoremap [Unite]  <Nop>
nmap <Space>  [Unite]

nnoremap [Unite]<Space>  :<C-u>Unite<Space>
nnoremap <silent> [Unite]f  :<C-u>Unite buffer file_mru file<Return>
nnoremap <silent> [Unite]g  :<C-u>UniteWithBufferDir file file_rec<Return>
nnoremap <silent> [Unite]b  :<C-u>Unite buffer<Return>
nnoremap <silent> [Unite]r  :<C-u>Unite register<Return>
" }}}

" unite alias {{{
let g:unite_source_alias_aliases = {
\   'memo' : {
\       'source': 'file_rec',
\       'args': '~/Dropbox/memo/',
\       'description': 'my memo files',
\   },
\   'tmp' : {
\       'source': 'file_rec',
\       'args': '~/Dropbox/tmp/',
\   },
\   'opera' : {
\       'source': 'file_rec',
\       'args': '~/Dropbox/config/opera/',
\   },
\   'vim' : {
\       'source': 'file_rec',
\       'args': '~/.vim/',
\   },
\   'junk' : {
\       'source': 'file_rec',
\       'args': '~/tmp/junk/',
\   },
\   'keymap' : {
\       'source': 'output',
\       'args': ['map', 'map!', 'lmap'],
\   },
\ }
" }}}

" static template file {{{
let read_action = {
\   'is_selectable' : 1,
\   'description' : 'Read file contents and write into a current buffer.',
\ }

function! read_action.func(candidates)
    for l:candidate in a:candidates
        " write at current line -1
        call unite#util#smart_execute_command(':.-1 read', l:candidate.action__path)
    endfor
endfunction

call unite#custom_action('file', 'read', read_action)

unlet read_action

function! s:unite_load_template_files()
    let l:type = (&filetype != '') ? &filetype . '/' : ''
    let l:dir = expand('~/.vim/template/' . l:type)
    if !filereadable(l:dir)
        let l:dir = expand('~/.vim/template/')
    endif
    call unite#start(['file_rec'], {
    \        'input': l:dir,
    \        'default_action': 'read'
    \    })
endfunction

nnoremap [Unite]t  :call <SID>unite_load_template_files()<Return>
" }}}

" /unite }}}

" caw {{{
vmap <Space>/  <Plug>(caw:i:toggle)
nmap <Space>/  <Plug>(caw:i:toggle)
" }}}

" matchit {{{
:source $VIMRUNTIME/macros/matchit.vim
" }}}

" quickrun {{{

let g:quickrun_config = {
\  '_': {
\    'outputter/buffer/split': 'aboveleft'
\  },
\  'javascript': {
\    'command': '$HOME/app/ringo/bin/ringo',
\    'tempfile': '%{tempname()}.js',
\    'exec': '%c %s'
\  },
\  'sql': {
\    'command': 'sqlplus',
\    'cmdopt': '-S',
\    'args': '%{g:get_oracle_connection("quickrun")}',
\    'tempfile': '%{tempname()}.sql',
\    'exec': '%c %o %a \@%s'
\  },
\}

" to quickrun sql {{{
function! g:get_oracle_connection(mode)
    let l:user_pass = s:get_option('oracle_user_pass', 'system/oracle')
    let l:sid = s:get_option('oracle_sid', 'localhost/xe')
    let l:sep = (a:mode == 'quickrun') ? '\\\@' : '@'
    let l:conn = l:user_pass . l:sep . l:sid
    return l:conn
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

" quickhl {{{
nnoremap [QuickHilite]  <Nop>
nmap ,  [QuickHilite]
xmap ,  [QuickHilite]
nmap [QuickHilite]m  <Plug>(quickhl-toggle)
xmap [QuickHilite]m  <Plug>(quickhl-toggle)
nmap [QuickHilite]M  <Plug>(quickhl-reset)
xmap [QuickHilite]M  <Plug>(quickhl-reset)
nmap [QuickHilite]j  <Plug>(quickhl-match)
" }}}

" neocomplcache {{{
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_auto_completion_start_length = 3

" <CR>: close popup
inoremap <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"
" <TAB>: completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <Esc>: cancel completion if completing
inoremap <expr><Esc>  neocomplcache#cancel_popup() . "\<Esc>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h>  neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr><BS>  neocomplcache#smart_close_popup() . "\<C-h>"

" Override <C-o>p key mapping which is defined above.
" Because the completion will not end after pasting
" when executing '<C-r><C-o>+' in insert mode.
if s:in_nix
    inoremap <expr><C-o>p  neocomplcache#cancel_popup() . "\<C-r><C-o>+"
else
    inoremap <expr><C-o>p  neocomplcache#cancel_popup() . "\<C-r><C-o>*"
endif
" }}}

" ambicmd {{{
cnoremap <expr><Space>  ambicmd#expand("\<Space>")
cnoremap <expr><C-Return>  ambicmd#expand("\<Return>")
" }}}

" vimfiler {{{
let g:vimfiler_as_default_explorer = 1

call vimfiler#set_execute_file(
\   'bat,c,cc,cpp,css,cxx,groovy,gradle,h,hpp,html,'.
\   'java,js,jsp,log,m,markdown,md,mkd,pl,properties,'.
\   'py,rb,sh,sql,tag,taskpaper,txt,vim,xml,yaml',
\   'vim')
" }}}

" dois.vim {{{
let g:dois_file = $HOME . '/Dropbox/tmp/doinglist.taskpaper'
let g:dois_dir = $HOME . '/Dropbox/tmp/doinglist'
nmap <C-Return>  <Plug>(dois:n:add-daily-task)
" }}}

" /plugin }}}


" autocmd {{{

" Create non-existing diretories automatically when the file is saved.
function! s:auto_mkdir(dir, force)
    if isdirectory(a:dir)
        return
    endif
    if a:force || input(printf('mkdir %s? [y/n] ', a:dir), 'y') =~? '^y\%[es]$'
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction
autocmd my BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)

" }}}


" finally {{{
" ------------------------------------------------------------------------
call s:load_local_vimrc()
set secure
" /finally }}}


" @see :help modeline
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
