autocmd BufNewFile,BufRead .editorconfig UltiSnipsAddFiletypes editorconfig
autocmd BufNewFile,BufRead .prettier.config.js UltiSnipsAddFiletypes prettierconfigjs
autocmd BufNewFile,BufRead rollup.config.js UltiSnipsAddFiletypes rollupconfigjs

"{ Auto commands" Do not use smart case in command line mode,
" extracted from https://goo.gl/vCTYdK
augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
augroup END
