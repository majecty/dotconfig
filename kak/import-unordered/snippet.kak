declare-option -hidden str jhconfig_kak_snippet_path "%opt{jhconfig_kak_path}/snippets"

declare-user-mode jh-snippet
map global user -docstring 'snippet user mode' s ':enter-user-mode jh-snippet<ret>'
map global jh-snippet -docstring 'snippet paste' s %{!fd snippet$ $kak_opt_jhconfig_kak_snippet_path/$kak_opt_filetype | fzf-tmux -d 30% | xargs cat<ret>}
map global jh-snippet -docstring 'new a snippet' n ":tmux-terminal-horizontal zsh -c ""cd %opt{jhconfig_kak_snippet_path};zsh""<ret>"

