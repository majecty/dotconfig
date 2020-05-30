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
nnoremap <C-n> :noh<CR>

nnoremap <leader>bd :bd<CR><C-G>

" copied from https://stackoverflow.com/a/51424640/2756490
let s:fontsize = 12
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Dejavu Sans Mono:h" . s:fontsize
endfunction

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

nmap <c-s> :w<CR>
vmap <c-s> <Esc><c-s>gv
imap <c-s> <Esc><c-s>

