" ========================================================================
"     plugins.vim
" ========================================================================


set nocompatible

" vim-plug {{{
if has('vim_starting')
    set runtimepath+=~/.vim/plugins/vim-plug/
endif

call plug#begin(expand('~/.vim/plugins'))


" plug itself
Plug 'https://github.com/junegunn/vim-plug.git', { 'dir': '~/.vim/plugins/vim-plug/autoload' }

" plug list {{{
Plug 'https://github.com/cohama/agit.vim.git'
Plug 'https://github.com/cohama/vim-hier.git'
Plug 'https://github.com/fatih/vim-go.git'
Plug 'https://github.com/google/vim-ft-go.git'
Plug 'https://github.com/gregsexton/gitv.git'
Plug 'https://github.com/h1mesuke/vim-alignta.git'
Plug 'https://github.com/hail2u/vim-css3-syntax.git'
Plug 'https://github.com/inside/unite-argument.git'
Plug 'https://github.com/justinmk/vim-dirvish.git'
Plug 'https://github.com/kamichidu/vim-textobj-function-go.git'
Plug 'https://github.com/kana/vim-altr.git'
Plug 'https://github.com/kana/vim-grex.git'
Plug 'https://github.com/kana/vim-niceblock.git'
Plug 'https://github.com/kana/vim-operator-replace.git'
Plug 'https://github.com/kana/vim-operator-siege.git'
Plug 'https://github.com/kana/vim-operator-user.git'
Plug 'https://github.com/kana/vim-submode.git'
Plug 'https://github.com/kana/vim-tabpagecd.git'
Plug 'https://github.com/kana/vim-textobj-function.git'
Plug 'https://github.com/kana/vim-textobj-lastpat.git'
Plug 'https://github.com/kana/vim-textobj-line.git'
Plug 'https://github.com/kana/vim-textobj-user.git'
Plug 'https://github.com/Konfekt/FastFold.git'
Plug 'https://github.com/kchmck/vim-coffee-script.git'
Plug 'https://github.com/lambdalisue/vim-gita.git'
Plug 'https://github.com/LeafCage/unite-recording.git'
Plug 'https://github.com/leafgarland/typescript-vim.git'
Plug 'https://github.com/mattn/gist-vim.git'
Plug 'https://github.com/mattn/sonictemplate-vim.git'
Plug 'https://github.com/mattn/vim-textobj-url.git'
Plug 'https://github.com/mattn/webapi-vim.git'
Plug 'https://github.com/mxw/vim-jsx.git'
Plug 'https://github.com/osyo-manga/shabadou.vim.git'
Plug 'https://github.com/osyo-manga/unite-quickfix.git'
Plug 'https://github.com/osyo-manga/vim-operator-jump_side.git'
Plug 'https://github.com/osyo-manga/vim-textobj-from_regexp.git'
Plug 'https://github.com/osyo-manga/vim-watchdogs.git'
Plug 'https://github.com/pangloss/vim-javascript.git'
Plug 'https://github.com/rcmdnk/vim-markdown.git'
Plug 'https://github.com/rhysd/clever-f.vim.git'
Plug 'https://github.com/scheakur/vim-demitas.git'
Plug 'https://github.com/scheakur/vim-dois.git'
Plug 'https://github.com/scheakur/vim-jsdocy.git'
Plug 'https://github.com/scheakur/vim-repautocd.git'
Plug 'https://github.com/scheakur/vim-scheakur.git'
Plug 'https://github.com/scheakur/vim-silentshout.git'
Plug 'https://github.com/scheakur/vim-skrap.git'
Plug 'https://github.com/scheakur/vim-taskbin.git'
Plug 'https://github.com/scheakur/vim-unvoice.git'
Plug 'https://github.com/scheakur/vim-winput.git'
Plug 'https://github.com/Shougo/neomru.vim.git'
Plug 'https://github.com/Shougo/neosnippet.vim.git'
Plug 'https://github.com/Shougo/tabpagebuffer.vim.git'
Plug 'https://github.com/Shougo/unite.vim.git'
Plug 'https://github.com/Shougo/vimfiler.vim.git'
Plug 'https://github.com/Shougo/vimproc.vim.git', { 'do': 'make' }
Plug 'https://github.com/sorah/unite-ghq.git'
Plug 'https://github.com/terryma/vim-expand-region.git'
Plug 'https://github.com/thinca/vim-localrc.git'
Plug 'https://github.com/thinca/vim-qfreplace.git'
Plug 'https://github.com/thinca/vim-quickrun.git'
Plug 'https://github.com/thinca/vim-textobj-between.git'
Plug 'https://github.com/thinca/vim-textobj-function-javascript.git'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/tpope/vim-repeat.git'
Plug 'https://github.com/tyru/caw.vim.git'
Plug 'https://github.com/tyru/open-browser.vim.git'
Plug 'https://github.com/tyru/operator-camelize.vim.git'
Plug 'https://github.com/udalov/kotlin-vim.git'
Plug 'https://github.com/vim-jp/vimdoc-ja.git'
Plug 'https://github.com/vim-jp/vim-go-extra.git'
Plug 'https://github.com/vim-jp/vital.vim.git'
Plug 'https://github.com/vim-ruby/vim-ruby.git'
Plug 'https://github.com/vim-scripts/groovyindent-unix.git'
Plug 'https://github.com/vim-scripts/tracwiki.git'
" }}}

call plug#end()
" }}}


" vim: set foldenable foldmethod=marker :
" vim: set formatoptions& formatoptions-=ro :
