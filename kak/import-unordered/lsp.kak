# eval %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(rust|javascript|html|typescript) %{
    lsp-enable-window
}

hook global WinSetOption filetype=(rust|typescript) %{
  set-option global lsp_auto_highlight_references true
}

map -docstring 'toggle-hover' global insert <c-l> '<esc>:jh-lsp-hover-toggle<ret>i'
map -docstring 'toggle-hover' global normal  <c-l> ':jh-lsp-hover-toggle<ret>'

declare-option -docstring "toggle statue of lsp" -hidden bool jh_lsp_hover_toggle true
# initialize to true. this is global scope
lsp-auto-hover-enable

define-command -hidden jh-lsp-hover-enable -docstring "enable lsp hover" %{
  lsp-auto-hover-enable
  lsp-auto-hover-insert-mode-enable
  set-option buffer jh_lsp_hover_toggle true
}
define-command -hidden jh-lsp-hover-disable -docstring "disable lsp hover" %{
  lsp-auto-hover-disable
  lsp-auto-hover-insert-mode-disable
  set-option buffer jh_lsp_hover_toggle false
}
define-command -hidden jh-lsp-hover-toggle -docstring "toggle lsp hover" %{ lua %opt{jh_lsp_hover_toggle} %{
  local is_on = args()
  if is_on then
    kak.jh_lsp_hover_disable()
  else
    kak.jh_lsp_hover_enable()
  end
}}

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
  (RUST_BACKTRACE=full kak-lsp -s $kak_session -vv ) > /tmp/lsp_kak-lsp_log 2>&1 < /dev/null &
}
