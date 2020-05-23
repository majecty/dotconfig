autocmd BufNewFile,BufRead .editorconfig UltiSnipsAddFiletypes editorconfig

"{ Auto commands" Do not use smart case in command line mode,
" extracted from https://goo.gl/vCTYdK
augroup dynamic_smartcase
    autocmd!
    autocmd CmdLineEnter : set nosmartcase
    autocmd CmdLineLeave : set smartcase
augroup END
