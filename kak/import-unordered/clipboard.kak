map global user -docstring 'paste (after) from clipboard' P '!xclip -selection clipboard -o'
map global user -docstring 'paste (before) from clipboard' p '<a-!>xclip -selection clipboard -o'

hook global NormalKey y|d|c %{ nop %sh{
    printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

