hook global WinSetOption filetype=html %{
    set-option window lintcmd 'run() { cat "$1" | eslint -f `yarn global dir`/node_modules/eslint-formatter-kakoune/index.js --stdin --stdin-filename "$kak_buffile";} && run '
    set-option window formatcmd 'prettier --parser html'
    lint-enable
}

