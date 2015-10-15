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
	set guifont=Ricty\ 12
	set guifontwide=Ricty\ 12
endif
" }}}


" window size {{{
if s:mac
	set lines=48
	set columns=100
endif

if s:nix
	if &diff
		set lines=99
		set columns=300
	else
		set lines=80
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
	set iminsert=2
endif
" }}}


" @see :help modeline
" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
