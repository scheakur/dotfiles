" ============================================================================ "
"                                   gvimrc                                     "
" ============================================================================ "


" basic {{{
set encoding=utf-8
scriptencoding utf-8
language messages C

" environment {{{
let s:mac = has('mac') || has('macunix')
let s:nix = !s:mac && has('unix')
" }}}

set background=light
colorscheme scheakur
" }}}


" font {{{
if s:mac
	set guifontwide=Monaco:h14
	set guifont=Monaco:h14
	set linespace=1
elseif s:nix
	set guifont=Migu\ 1M\ 12
	set guifontwide=Migu\ 1M\ 12
endif
" }}}


" window size {{{
if s:mac
	set lines=48
	set columns=200
endif

if s:nix
	if &diff
		set lines=60
		set columns=300
	else
		set lines=60
		set columns=200
	endif
endif
" }}}


" guioption {{{
set guioptions&
set guioptions-=e
set guioptions-=m
set guioptions-=r
set guioptions-=L
set guioptions-=T
set langmenu=none
" }}}


" macvim {{{
if has('gui_macvim')
	set noimdisable
	set iminsert=0
endif
" }}}


" @see :help modeline
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
