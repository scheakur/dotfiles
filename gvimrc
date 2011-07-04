" ========================================================================
"     gvimrc
" ========================================================================

colorscheme newspaper

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
endif

set guioptions& 
set guioptions-=m
set guioptions-=r
set guioptions-=L
set guioptions-=T
set langmenu=none
language messages C

" vim: set foldenable foldmethod=marker : @see |modeline|
