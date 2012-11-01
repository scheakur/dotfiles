scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

let s:hook = shabadou#make_hook_command({
\   "config" : {
\       "hook_command" : ':call',
\       "hook_args": 'feedkeys("\<C-w>p")'
\   }
\})


function! s:hook.on_success(...)
    if self.config.enable_success
        let self.config.enable_exit = 1
    endif
endfunction


function! s:hook.on_failure(...)
    if self.config.enable_failure
        let self.config.enable_exit = 1
    endif
endfunction


function! quickrun#hook#back_to_previous_window#new()
    return deepcopy(s:hook)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
