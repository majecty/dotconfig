hook global WinSetOption filetype=javascript %{
    set-option window lintcmd 'run() { cat "$1" | eslint -f `yarn global dir`/node_modules/eslint-formatter-kakoune/index.js --stdin --stdin-filename "$kak_buffile";} && run '
    # using npx to run local eslint over global
    # formatting with prettier `npm i prettier --save-dev`
    set-option window formatcmd 'prettier --parser flow'

    lint-enable
}

