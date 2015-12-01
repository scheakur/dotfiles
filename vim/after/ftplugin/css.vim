setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2
setlocal iskeyword+=-,@-@,#,$,%,.
setlocal dictionary=$HOME/.vim/dict/css.dict

command! -buffer -range=% FormatColorCode  <line1>,<line2>s/#\x\{3,6}/\L\0/g | nohlsearch
