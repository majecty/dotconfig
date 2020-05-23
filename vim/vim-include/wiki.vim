let wiki = {}
let wiki.path = $HOME . '/vim-jekyll-wiki/_wiki/'
let wiki.ext = '.md'

let g:vimwiki_list = [wiki]
let g:vimwiki_conceallevel = 0

nmap <Leader>t :VimwikiTable<CR>

function! NewTemplate()

    let l:wiki_directory = v:false

    for wiki in g:vimwiki_list
        if expand('%:p:h') . '/' == wiki.path
            let l:wiki_directory = v:true
            break
        endif
    endfor

    if !l:wiki_directory
        return
    endif

    if line("$") > 1
        return
    endif

    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'layout  : wiki')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'tags    : ')
    call add(l:template, 'toc     : true')
    call add(l:template, 'public  : true')
    call add(l:template, 'parent  : ')
    call add(l:template, 'latex   : false')
    call add(l:template, '---')
    call add(l:template, '* TOC')
    call add(l:template, '{:toc}')
    call add(l:template, '')
    call add(l:template, '# ')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'

    echom 'new wiki page has created'
endfunction

function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        keepjumps exe '1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfun

augroup vimwikiauto
    autocmd BufWritePre *wiki/*.md call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplate()
    " Search text on curser in the wiki
    autocmd BufRead *wiki/*.md nnoremap <buffer> <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>
    " Show pages that links to this page
    autocmd BufRead *wiki/*.md nnoremap <buffer> <F5> :execute "VWB" <Bar> :lopen<CR>

augroup END

let g:md_modify_disabled = 0
