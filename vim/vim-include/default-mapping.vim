" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

imap <C-L> <ESC>

nnor ,cf :let @+=expand("%:p")<CR>    " Mnemonic: Copy File path
nnor ,yf :let @"=expand("%:p")<CR>    " Mnemonic: Yank File path
nnor ,fn :let @"=expand("%")<CR>      " Mnemonic: yank File Name
