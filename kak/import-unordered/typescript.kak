hook global WinSetOption filetype=typescript %{
  set-option window formatcmd 'prettier --parser typescript'
}
