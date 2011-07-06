" ========================================================================
"     vimrc
" ========================================================================


" basic {{{
" ------------------------------------------------------------------------
scriptencoding utf-8
" disable vi compatible mode
set nocompatible

" clear command
augroup MyAutoCmd
  autocmd!
augroup END

" user interface in English
language messages C
language time C

syntax enable

" vundle {{{
filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
" vundle itself
Bundle 'git://github.com/gmarik/vundle.git'

" vundle list {{{
Bundle 'git://github.com/Shougo/unite.vim.git'
Bundle 'git://github.com/tyru/caw.vim.git'
Bundle 'git://github.com/tacroe/unite-alias.git'
Bundle 'git://github.com/vim-scripts/newspaper.vim.git'
Bundle 'git://github.com/vim-scripts/Lucius.git'
" }}}

filetype plugin on
filetype indent on
" }}}

" color {{{
colorscheme lucius
" overwrite some colors {{{
highlight IncSearch cterm=reverse ctermfg=0 gui=reverse ctermbg=11 guifg=#2e3436 guibg=#fcaf3e
highlight Search    cterm=NONE    ctermfg=0 gui=NONE    ctermbg=11 guifg=#2e3436 guibg=#fcaf3e
" }}}
" }}}

" }}}


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
" }}}

" backup & swap & undo {{{
set nowritebackup
set nobackup
set directory-=.
set undofile
let &undodir=&directory
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
set virtualedit=block
" }}}

" completion {{{
set wildignore&
set wildignore+=.git,.svn,*.class
set nowildmenu
set wildmode=list:longest,full
" }}}

" }}}


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

" junk file {{{
command! -nargs=0 JunkFile call s:open_junk_file('txt')
function! s:open_junk_file(ext)
  let l:junk_dir = $HOME . '/tmp/junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk File: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.') . a:ext)
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

" }}}


" standard keymap {{{
" ------------------------------------------------------------------------

" map leader {{{
let mapleader = ','
let maplocalleader = '.'
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
nnoremap Y  y$
vnoremap <  <gv
vnoremap >  >gv
nnoremap n  nzz
nnoremap N  Nzz

inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>
inoremap <C-d>  <Delete>
nnoremap <expr> s*  ':%s/\<' . expand('<cword>') . '\>//g<Left><Left>'
nnoremap O  :<C-u>call append(expand('.'), '')<Return>j
nnoremap <Space>M  :<C-u>marks<Return>:mark<Space>
" }}}

" command line mode {{{
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-l> <Right>
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'
" }}}

" toggle option {{{
function! s:ToggleOption(option_name)
    execute 'setlocal ' . a:option_name . '!'
    execute 'setlocal ' . a:option_name . '?'
endfunction
nnoremap <silent> <Space>ow  :<C-u>call <SID>ToggleOption('wrap')<Return>
nnoremap <silent> <Space>nu  :<C-u>call <SID>ToggleOption('number')<Return>
nnoremap <silent> <Space>hl  :<C-u>call <SID>ToggleOption('hlsearch')<Return>
" }}}

" current date/time {{{
inoremap <Leader>dF <C-r>=strftime('%Y-%m-%dT%H:%M:%S%z')<Return>
inoremap <Leader>df <C-r>=strftime('%Y-%m-%d %H:%M:%S')<Return>
inoremap <Leader>dd <C-r>=strftime('%Y-%m-%d')<Return>
inoremap <Leader>dm <C-r>=strftime('%Y-%m')<Return>
inoremap <Leader>dy <C-r>=strftime('%Y')<Return>
inoremap <Leader>dT <C-r>=strftime('%H:%M:%S')<Return>
inoremap <Leader>dt <C-r>=strftime

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
nnoremap [Window]w  <C-w>c
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

" handle tags {{{
nnoremap [Tag]  <Nop>
nmap <C-t>  [Tag]
nnoremap [Tag]<C-t>  <C-]>
nnoremap [Tag]<C-j>  :<C-u>tag<Return>
nnoremap [Tag]<C-k>  :<C-u>pop<Return>
" }}}

" change current directory
nnoremap <silent> <Space>cd :<C-u>CD<Return>

" yank filename {{{
nnoremap <silent> <Space>yf  :let @@=expand("%:p")<Return>
nnoremap <silent> <Space>yy  :let @@=expand("%")<Return>
" }}}

" }}}


" plugin {{{

" unite {{{

" option {{{
let g:unite_split_rule = 'aboveleft'
" }}}

" keymap {{{
nnoremap [Unite]  <Nop>
nmap <Space>  [Unite]

nnoremap [Unite]<Space>  :<C-u>Unite<Space>
nnoremap <silent> [Unite]ff  :<C-u>Unite file<Return>
nnoremap <silent> [Unite]fm  :<C-u>Unite file_mru<Return>
nnoremap <silent> [Unite]b  :<C-u>Unite buffer<Return>
nnoremap <silent> [Unite]r  :<C-u>Unite register<Return>
" }}}

" unite alias {{{
let g:unite_source_alias_aliases = {
\   'memo' : {
\     'source': 'file_rec',
\     'args': '~/Dropbox/memo',
\     'description': 'my memo files',
\   },
\   'tmp' : {
\     'source': 'file_rec',
\     'args': '~/Dropbox/tmp',
\   },
\   'opera' : {
\     'source': 'file_rec',
\     'args': '~/Dropbox/config/opera',
\   },
\   'junk' : {
\     'source': 'file_rec',
\     'args': '~/tmp/junk',
\   },
\ }
"}}}

" }}}


" caw {{{
vmap <Space>/  <Plug>(caw:i:toggle)
nmap <Space>/  <Plug>(caw:i:toggle)
" }}}

" }}}


" finally {{{
" ------------------------------------------------------------------------
if filereadable(expand('~/.vimrc.local'))
    try
        execute 'source' expand('~/.vimrc.local')
    catch
      " TODO do not ignore errors
    endtry
endif
set secure
" }}}


" vim: set foldenable foldmethod=marker : @see :help modeline
