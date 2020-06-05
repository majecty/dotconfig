# eval %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(rust|javascript) %{
    lsp-enable-window
}

lsp-auto-hover-enable
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

# output debug logs for kak-lsp
# nop %sh{
#  (kak-lsp -s $kak_session -vvv ) > /tmp/lsp_"$(date +%F-%T-%N)"_kak-lsp_log 2>&1 < /dev/null &
# }
# lsp-auto-hover-enable
