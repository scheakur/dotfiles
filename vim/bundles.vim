" ========================================================================
"     bundles.vim
" ========================================================================

set nocompatible

" neobundle {{{
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))


" neobundle itself
NeoBundle 'https://github.com/Shougo/neobundle.vim.git'

" neobundle list {{{
NeoBundle 'https://github.com/clausreinke/typescript-tools.git'
NeoBundle 'https://github.com/cohama/agit.vim.git'
NeoBundle 'https://github.com/cohama/vim-hier.git'
NeoBundle 'https://github.com/google/vim-ft-go.git'
NeoBundle 'https://github.com/gregsexton/gitv.git'
NeoBundle 'https://github.com/h1mesuke/vim-alignta.git'
NeoBundle 'https://github.com/JuliaLang/julia-vim.git'
NeoBundle 'https://github.com/kana/vim-altr.git'
NeoBundle 'https://github.com/kana/vim-grex.git'
NeoBundle 'https://github.com/kana/vim-niceblock.git'
NeoBundle 'https://github.com/kana/vim-operator-replace.git'
NeoBundle 'https://github.com/kana/vim-operator-siege.git'
NeoBundle 'https://github.com/kana/vim-operator-user.git'
NeoBundle 'https://github.com/kana/vim-submode.git'
NeoBundle 'https://github.com/kana/vim-tabpagecd.git'
NeoBundle 'https://github.com/kana/vim-textobj-function.git'
NeoBundle 'https://github.com/kana/vim-textobj-lastpat.git'
NeoBundle 'https://github.com/kana/vim-textobj-line.git'
NeoBundle 'https://github.com/kana/vim-textobj-user.git'
NeoBundle 'https://github.com/kchmck/vim-coffee-script.git'
NeoBundle 'https://github.com/leafgarland/typescript-vim.git'
NeoBundle 'https://github.com/mattn/gist-vim.git'
NeoBundle 'https://github.com/mattn/sonictemplate-vim.git'
NeoBundle 'https://github.com/mattn/vim-textobj-url.git'
NeoBundle 'https://github.com/mattn/webapi-vim.git'
NeoBundle 'https://github.com/mxw/vim-jsx.git'
NeoBundle 'https://github.com/osyo-manga/shabadou.vim.git'
NeoBundle 'https://github.com/osyo-manga/unite-quickfix.git'
NeoBundle 'https://github.com/osyo-manga/vim-watchdogs.git'
NeoBundle 'https://github.com/pangloss/vim-javascript.git'
NeoBundle 'https://github.com/rcmdnk/vim-markdown.git'
NeoBundle 'https://github.com/rhysd/clever-f.vim.git'
NeoBundle 'https://github.com/rhysd/vim-operator-surround.git'
NeoBundle 'https://github.com/scheakur/vim-demitas.git'
NeoBundle 'https://github.com/scheakur/vim-dois.git'
NeoBundle 'https://github.com/scheakur/vim-jsdocy.git'
NeoBundle 'https://github.com/scheakur/vim-repautocd.git'
NeoBundle 'https://github.com/scheakur/vim-scheakur.git'
NeoBundle 'https://github.com/scheakur/vim-skrap.git'
NeoBundle 'https://github.com/scheakur/vim-taskbin.git'
NeoBundle 'https://github.com/scheakur/vim-unvoice.git'
NeoBundle 'https://github.com/scheakur/vim-winput.git'
NeoBundle 'https://github.com/Shougo/neomru.vim.git'
NeoBundle 'https://github.com/Shougo/neosnippet.vim.git'
NeoBundle 'https://github.com/Shougo/tabpagebuffer.vim.git'
NeoBundle 'https://github.com/Shougo/unite.vim.git'
NeoBundle 'https://github.com/Shougo/vimfiler.vim.git'
NeoBundle 'https://github.com/Shougo/vimproc.vim.git', {
\	'build' : {
\		'windows': 'make -f make_mingw32.mak',
\		'cygwin': 'make -f make_cygwin.mak',
\		'mac': 'make -f make_mac.mak',
\		'unix': 'make -f make_unix.mak',
\	},
\}
NeoBundle 'https://github.com/sorah/unite-ghq.git'
NeoBundle 'https://github.com/thinca/vim-localrc.git'
NeoBundle 'https://github.com/thinca/vim-qfreplace.git'
NeoBundle 'https://github.com/thinca/vim-quickrun.git'
NeoBundle 'https://github.com/thinca/vim-textobj-between.git'
NeoBundle 'https://github.com/thinca/vim-textobj-function-javascript.git'
NeoBundle 'https://github.com/tpope/vim-commentary.git'
NeoBundle 'https://github.com/tpope/vim-fugitive.git'
NeoBundle 'https://github.com/tpope/vim-repeat.git'
NeoBundle 'https://github.com/tyru/open-browser.vim.git'
NeoBundle 'https://github.com/tyru/operator-camelize.vim.git'
NeoBundle 'https://github.com/vim-jp/vimdoc-ja.git'
NeoBundle 'https://github.com/vim-jp/vim-go-extra'
NeoBundle 'https://github.com/vim-jp/vital.vim.git'
NeoBundle 'https://github.com/vim-ruby/vim-ruby.git'
NeoBundle 'https://github.com/vim-scripts/groovyindent.git'
NeoBundle 'https://github.com/vim-scripts/Lucius.git'
NeoBundle 'https://github.com/vim-scripts/newspaper.vim.git'
" }}}

" try {{{
NeoBundleLocal ~/.vim/try
" }}}

call neobundle#end()
" }}}


" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
