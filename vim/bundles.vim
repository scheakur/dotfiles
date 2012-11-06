" ========================================================================
"     bundles.vim
" ========================================================================

" neobundle {{{
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))


" neobundle itself
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'

" neobundle list {{{
NeoBundle 'git://github.com/h1mesuke/vim-alignta.git'
NeoBundle 'git://github.com/h1mesuke/unite-outline.git'
NeoBundle 'git://github.com/jceb/vim-hier.git'
NeoBundle 'git://github.com/jnwhiteh/vim-golang'
NeoBundle 'git://github.com/jsx/jsx.vim.git'
NeoBundle 'git://github.com/kana/vim-niceblock.git'
NeoBundle 'git://github.com/kana/vim-operator-user.git'
NeoBundle 'git://github.com/kana/vim-operator-replace.git'
NeoBundle 'git://github.com/kana/vim-smartchr.git'
NeoBundle 'git://github.com/kana/vim-smartinput.git'
NeoBundle 'git://github.com/kana/vim-tabpagecd.git'
NeoBundle 'git://github.com/kana/vim-textobj-line.git'
NeoBundle 'git://github.com/kana/vim-textobj-user.git'
NeoBundle 'git://github.com/kchmck/vim-coffee-script.git'
NeoBundle 'git://github.com/osyo-manga/shabadou.vim.git'
NeoBundle 'git://github.com/osyo-manga/unite-quickfix.git'
NeoBundle 'git://github.com/osyo-manga/vim-watchdogs.git'
NeoBundle 'git://github.com/pangloss/vim-javascript.git'
NeoBundle 'git://github.com/scheakur/dois.vim.git'
NeoBundle 'git://github.com/scheakur/scheakur.vim.git'
NeoBundle 'git://github.com/Shougo/neosnippet.git'
NeoBundle 'git://github.com/Shougo/vimfiler.git'
NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/t9md/vim-unite-ack.git'
NeoBundle 'git://github.com/thinca/vim-ambicmd.git'
NeoBundle 'git://github.com/thinca/vim-localrc.git'
NeoBundle 'git://github.com/thinca/vim-quickrun.git'
NeoBundle 'git://github.com/thinca/vim-ref.git'
NeoBundle 'git://github.com/thinca/vim-textobj-plugins.git'
NeoBundle 'git://github.com/tpope/vim-surround.git'
NeoBundle 'git://github.com/tpope/vim-repeat.git'
NeoBundle 'git://github.com/tyru/caw.vim.git'
NeoBundle 'git://github.com/tyru/open-browser.vim.git'
NeoBundle 'git://github.com/vim-jp/vimdoc-ja.git'
NeoBundle 'git://github.com/vim-scripts/groovyindent.git'
NeoBundle 'git://github.com/vim-scripts/newspaper.vim.git'
NeoBundle 'git://github.com/vim-scripts/Lucius.git'
NeoBundle 'git://github.com/vim-scripts/sudo.vim.git'
" }}}

" try {{{
NeoBundleLocal ~/.vim/try
" }}}

" }}}


" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
