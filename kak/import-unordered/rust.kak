hook global WinSetOption filetype=rust %{
    set-option window lintcmd 'run() { cac;} && run'
    # using npx to run local eslint over global
    # formatting with prettier `npm i prettier --save-dev`
    set-option window formatcmd '/home/juhyung/.rustup/toolchains/nightly-2020-05-05-x86_64-unknown-linux-gnu/bin/rustfmt'

    alias window fix format2 # the patched version, renamed to `format2`.
    lint-enable
}


