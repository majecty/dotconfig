let wiki = {}
let wiki.path = '~/vim-jekyll-wiki/_wiki/'
let wiki.ext = '.md'

let g:vimwiki_list = [wiki]
let g:vimwiki_conceallevel = 0

nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>
nnoremap <F4> :execute "VWB" <Bar> :lopen<CR>
