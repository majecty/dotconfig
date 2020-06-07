hook global WinSetOption filetype=html %{
    set-option window lintcmd 'run() { cat "$1" | eslint -f `yarn global dir`/node_modules/eslint-formatter-kakoune/index.js --stdin --stdin-filename "$kak_buffile";} && run '
    # using npx to run local eslint over global
    # formatting with prettier `npm i prettier --save-dev`
    set-option window formatcmd 'prettier --parser html'

    alias window fix format2 # the patched version, renamed to `format2`.
    lint-enable
}

