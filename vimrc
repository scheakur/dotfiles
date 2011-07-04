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
filetype plugin on
filetype indent on
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
set softtabstop=4
set shiftwidth=4
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

" misc {{{
set autoread
set backspace=indent,eol,start
set clipboard& clipboard+=unnamed
set modeline
set virtualedit=block
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
command! -nargs=0 Junk call s:open_junk_file('txt')
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

" rename file " {{{
command! -nargs=1 -complete=file Rename f <args>|w|call delete(expand('#'))
" }}}

" remove trail ^M " {{{
command! -range RemoveTrailM :setlocal nohlsearch | :<line1>,<line2>s!\r$!!g
" }}}

" }}}


" keymap {{{
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
vnoremap <  <gv
vnoremap >  >gv
nnoremap n  nzz
nnoremap N  Nzz
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-l> <Right>
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

" text-objects " {{{
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


" vim: set foldenable foldmethod=marker : @see |modeline|
