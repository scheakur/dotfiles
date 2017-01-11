setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal iskeyword+==,?,!,@-@,$
setlocal dictionary=$HOME/.vim/dict/ruby.dict

inoremap <buffer><expr> \|  vimrc#input_pair_char_nicely('\|', [' { ', ' do '])

setlocal foldmethod=syntax
setlocal foldtext=vimrc#make_folding_label()
