set --global __fish_git_prompt_show_informative_status  true
set --global __fish_git_prompt_showcolorhints           true

set --global __fish_git_prompt_char_dirtystate       '🌀 '
set --global __fish_git_prompt_char_stagedstate      '➕ '
set --global __fish_git_prompt_char_untrackedfiles   '❓ '
set --global __fish_git_prompt_char_stashstate       '📦 '
set --global __fish_git_prompt_char_upstream_ahead   '🔺 '
set --global __fish_git_prompt_char_upstream_behind  '🔻 '
set --global __fish_git_prompt_char_cleanstate       '🌟'
set --global __fish_git_prompt_char_invalidstate     '🔥 '


set --global fish_prompt_pwd_dir_length 0

function fish_prompt --description 'Write out the prompt'
    set -l last_status $status

    # DateTime
    set_color $fish_color_quote
    echo -n '['(date "+%H:%M:%S")']'
    set_color normal

    echo -n ' '

    # User
    set_color $fish_color_user
    echo -n (whoami)
    set_color normal

    echo -n '@'

    # Host
    set_color $fish_color_host
    echo -n (prompt_hostname)
    set_color normal

    echo -n ':'

    # PWD
    set_color $fish_color_cwd
    echo -n (prompt_pwd)
    set_color normal

    echo -n ' '

    # Git User
    set_color blue
    echo -n '@'(git config user.name)
    set_color normal

    # Git
    __fish_git_prompt
    __fish_hg_prompt
    echo

    if not test $last_status -eq 0
        set_color $fish_color_error
    end

    echo -n '> '
    set_color normal
end
