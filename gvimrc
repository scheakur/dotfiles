" ========================================================================
"     gvimrc
" ========================================================================

" basic {{{
scriptencoding utf-8
language messages C

" colorscheme {{{
colorscheme newspaper
" override {{{
highlight Normal      guifg=#252525
highlight Pmenu       guifg=#252525
highlight PmenuSel    gui=NONE guifg=#252525 guibg=#918d71
highlight Comment     gui=NONE
highlight SpecialKey  guifg=#004ec8 guibg=#ebebe0
highlight Folded      gui=NONE guifg=#ebebeb guibg=#677c53
" }}}
" }}}

" }}}


" font {{{
if has('mac')
  set guifontwide=Monaco:h14
  set guifont=Monaco:h14
  set linespace=1
  let $PATH='/opt/local/bin:'.$PATH
  set lines=48
  set columns=100
  set fuoptions=maxvert,maxhorz
elseif has('unix')
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
