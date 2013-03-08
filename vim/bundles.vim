" ========================================================================
"     bundles.vim
" ========================================================================

set nocompatible

" neobundle {{{
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))


" neobundle itself
NeoBundle 'https://github.com/Shougo/neobundle.vim.git'

" neobundle list {{{
NeoBundle 'https://github.com/h1mesuke/vim-alignta.git'
NeoBundle 'https://github.com/jceb/vim-hier.git'
NeoBundle 'https://github.com/jnwhiteh/vim-golang'
NeoBundle 'https://github.com/kana/vim-niceblock.git'
NeoBundle 'https://github.com/kana/vim-operator-user.git'
NeoBundle 'https://github.com/kana/vim-operator-replace.git'
NeoBundle 'https://github.com/kana/vim-tabpagecd.git'
NeoBundle 'https://github.com/kana/vim-textobj-function.git'
NeoBundle 'https://github.com/kana/vim-textobj-lastpat.git'
NeoBundle 'https://github.com/kana/vim-textobj-line.git'
NeoBundle 'https://github.com/kana/vim-textobj-user.git'
NeoBundle 'https://github.com/kchmck/vim-coffee-script.git'
NeoBundle 'https://github.com/mattn/gist-vim.git'
NeoBundle 'https://github.com/mattn/webapi-vim.git'
NeoBundle 'https://github.com/osyo-manga/shabadou.vim.git'
NeoBundle 'https://github.com/osyo-manga/unite-quickfix.git'
NeoBundle 'https://github.com/osyo-manga/vim-watchdogs.git'
NeoBundle 'https://github.com/pangloss/vim-javascript.git'
NeoBundle 'https://github.com/scheakur/vim-demitas.git'
NeoBundle 'https://github.com/scheakur/vim-dois.git'
NeoBundle 'https://github.com/scheakur/vim-scheakur.git'
NeoBundle 'https://github.com/scheakur/vim-skrap.git'
NeoBundle 'https://github.com/Shougo/neosnippet.git'
NeoBundle 'https://github.com/Shougo/vimfiler.git'
NeoBundle 'https://github.com/Shougo/vimproc.git'
NeoBundle 'https://github.com/Shougo/unite.vim.git'
NeoBundle 'https://github.com/thinca/vim-ambicmd.git'
NeoBundle 'https://github.com/thinca/vim-localrc.git'
NeoBundle 'https://github.com/thinca/vim-quickrun.git'
NeoBundle 'https://github.com/thinca/vim-ref.git'
NeoBundle 'https://github.com/thinca/vim-textobj-between.git'
NeoBundle 'https://github.com/thinca/vim-textobj-function-javascript.git'
NeoBundle 'https://github.com/tpope/vim-surround.git'
NeoBundle 'https://github.com/tpope/vim-repeat.git'
NeoBundle 'https://github.com/tyru/caw.vim.git'
NeoBundle 'https://github.com/tyru/open-browser.vim.git'
NeoBundle 'https://github.com/vim-jp/vimdoc-ja.git'
NeoBundle 'https://github.com/vim-ruby/vim-ruby.git'
NeoBundle 'https://github.com/vim-scripts/groovyindent.git'
NeoBundle 'https://github.com/vim-scripts/newspaper.vim.git'
NeoBundle 'https://github.com/vim-scripts/Lucius.git'
NeoBundle 'https://github.com/vim-scripts/sudo.vim.git'
" }}}

" try {{{
NeoBundleLocal ~/.vim/try
" }}}

" }}}


" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
