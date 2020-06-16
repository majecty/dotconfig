map global user -docstring 'paste (after) from X clipboard' P '!xclip -selection clipboard -o<ret>'
map global user -docstring 'paste (before) from X clipboard' p '<a-!>xclip -selection clipboard -o<ret>'
map global user -docstring 'paste (after) from tmux clipboard' <c-P> '!tmux show-buffer<ret>'
map global user -docstring 'paste (after) from tmux clipboard' <c-p> '<a-!>tmux show-buffer<ret>'

hook global NormalKey y|d|c %{ nop %sh{
    printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
    if [ -n $TMUX ]; then
        tmux set-buffer -- "$kak_main_reg_dquote"
    fi
}}

