hook global BufCreate .*zsh(rc|env)? %{
    set-option buffer filetype sh
}
