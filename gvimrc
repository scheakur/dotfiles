" ========================================================================
"     gvimrc
" ========================================================================

" basic {{{
scriptencoding utf-8
language messages C

" environment {{{
let s:in_win = has('win32') || has('win64')
let s:in_mac = has('mac') || has('macunix')
let s:in_nix = !s:in_mac && has('unix')
" }}}

colorscheme scheakur
" }}}


" font {{{
if s:in_mac
  set guifontwide=Monaco:h14
  set guifont=Monaco:h14
  set linespace=1
  let $PATH='/opt/local/bin:'.$PATH
  set lines=48
  set columns=100
  set fuoptions=maxvert,maxhorz
elseif s:in_nix
  set guifont=VL\ Gothic\ 12
  set guifontwide=VL\ Gothic\ 12
  set lines=40
  set columns=100
  winpos 400 90
else
  set guifont=VL\ Gothic:h12
  set guifontwide=VL\ Gothic:h12
  set lines=40
  set columns=100
endif
" }}}


" guioption {{{
set guioptions&
set guioptions-=m
set guioptions-=r
set guioptions-=L
set guioptions-=T
set langmenu=none
" }}}


" workaround {{{
" Resetting listchars.
" Unless resetting,  "･" is treat as "<5a>" in MacVim.
" I doubt encoding setting, but I couldn't specify the cause.
" TODO specify the cause
set listchars=tab:>-,trail:･
" }}}


" @see :help modeline
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
