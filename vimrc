" vimrc

" basic {{{
scriptencoding utf-8
set nocompatible

" user interface in English {{{
language messages C
language time C
"}}}

syntax enable
filetype plugin indent on
"}}}

" file encoding {{{
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>

command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
"}}}


" options {{{

" search {{{
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
"}}}

"}}}

" keymap {{{
"}}}

" finally {{{
if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
endif
set secure
" }}}
" vim: set foldenable foldmethod=marker
