"let g:LanguageClient_serverCommands = {
"\ 'rust': ['rust-analyzer'],
"\ }
"
"nnoremap <c-p> :call LanguageClient_contextMenu()<CR>
"" Or map each action separately
"nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
"nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
"nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
"nnoremap <silent> H :call LanguageClient#textDocument_documentHighlight()<CR>
"nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
