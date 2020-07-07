# eval %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(rust|javascript|html|typescript) %{
    lsp-enable-window
}

hook global WinSetOption filetype=(rust|typescript) %{
  set-option global lsp_auto_highlight_references true
}

lsp-auto-hover-enable
lsp-auto-signature-help-enable
set-option global lsp_hover_anchor true
set-option global lsp_hover_max_lines 20

hook global WinSetOption filetype=rust %{
  hook window -group rust-inlay-hints BufReload .* rust-analyzer-inlay-hints
  hook window -group rust-inlay-hints NormalIdle .* rust-analyzer-inlay-hints
  hook window -group rust-inlay-hints InsertIdle .* rust-analyzer-inlay-hints
  hook -once -always window WinSetOption filetype=.* %{
    remove-hooks window rust-inlay-hints
  }
}

map global goto i '<esc>: lsp-implementation<ret>' -docstring 'implementation'

map global lsp -docstring 'rename' 2 ':lsp-rename-prompt<ret>'

# output debug logs for kak-lsp
nop %sh{
  # (kak-lsp -s $kak_session -vvv ) > /tmp/lsp_"$(date +%F-%T-%N)"_kak-lsp_log 2>&1 < /dev/null &
  (RUST_BACKTRACE=full kak-lsp -s $kak_session -vvv ) > /tmp/lsp_kak-lsp_log 2>&1 < /dev/null &
}
