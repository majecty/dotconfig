hook global WinSetOption filetype=rust %{
    set-option window lintcmd 'run() { cac;} && run'
    # using npx to run local eslint over global
    # formatting with prettier `npm i prettier --save-dev`
    set-option window formatcmd '/home/juhyung/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rustfmt'

    lint-enable
}


