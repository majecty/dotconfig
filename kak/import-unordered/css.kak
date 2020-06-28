hook global WinSetOption filetype=css %{
    set-option window lintcmd 'yarn --silent csslint $kak_buffile'
    set-option window formatcmd 'yarn --silent prettier --parser css'
    lint-enable
}

