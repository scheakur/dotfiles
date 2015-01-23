" ============================================================================ "
"                                   gvimrc                                     "
" ============================================================================ "

" basic {{{
set encoding=utf-8
scriptencoding utf-8
language messages C

" environment {{{
let s:in_mac = has('mac') || has('macunix')
let s:in_nix = !s:in_mac && has('unix')
" }}}

set background=light
colorscheme scheakur
" }}}


" font {{{
if s:in_mac
	set guifontwide=Monaco:h14
	set guifont=Monaco:h14
	set linespace=1
	let $PATH='/opt/local/bin:'.$PATH
	set fuoptions=maxvert,maxhorz
elseif s:in_nix
	set guifont=Ricty\ 12
	set guifontwide=Ricty\ 12
endif
" }}}


" window size {{{
if s:in_mac
	set lines=48
	set columns=100
elseif s:in_nix
	if &diff
		set lines=999
		set columns=999
	else
		set lines=40
		set columns=100
		winpos 400 90
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
