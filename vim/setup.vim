" ========================================================================
"     setup.vim
"
"     USAGE:
"         vim -u ~/.vim/setup.vim
" ========================================================================

set nocompatible
execute 'source ' . expand('~/.vim/bundles.vim')

augroup mysetup
    autocmd!
    autocmd VimEnter * NeoBundleInstall
augroup end

" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
