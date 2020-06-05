# eval %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(rust) %{
    lsp-enable-window
}

# output debug logs for kak-lsp
# nop %sh{
#  (kak-lsp -s $kak_session -vvv ) > /tmp/lsp_"$(date +%F-%T-%N)"_kak-lsp_log 2>&1 < /dev/null &
# }
# lsp-auto-hover-enable
