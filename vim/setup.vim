" ========================================================================
"     setup.vim
"
"     USAGE:
"         vim -u ~/.vim/setup.vim
" ========================================================================

set nocompatible
execute 'source ' . expand('~/.vim/plugins.vim')

augroup mysetup
    autocmd!
    autocmd VimEnter * PlugInstall
augroup end

" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
