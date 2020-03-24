
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
            \ 'h:headings',
            \ 'l:links',
            \ 'i:images'
        \ ],
    \ "sort" : 0
\ }

let g:tagbar_type_vimwiki = {
    \ 'ctagstype' : 'vimwiki',
    \ 'sort': 0,
    \ 'kinds' : [
        \ 'h:Heading'
    \ ]
\ }

nmap <f8> :TagbarToggle<cr>
