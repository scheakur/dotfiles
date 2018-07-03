" ========================================================================
"     setup.vim
"
"     USAGE:
"         vim -u ~/.vim/setup.vim
" ========================================================================

set nocompatible

if has('win64')
    execute 'source ' . expand('~/vimfiles/plugins.vim')
else
    execute 'source ' . expand('~/.vim/plugins.vim')
endif

augroup mysetup
    autocmd!
    autocmd VimEnter * PlugInstall
augroup end

" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
