require-module fzf
require-module fzf-file
require-module fzf-grep

# Do not search hidden files
set-option global fzf_file_command 'rg -L --files'
set-option global fzf_grep_command 'rg'
set-option global fzf_highlight_command 'bat --color=always --style=plain --theme=OneHalfLight {}'
