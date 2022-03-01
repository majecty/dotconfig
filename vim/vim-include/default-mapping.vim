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
nnoremap <leader>wo <C-W>o

nnoremap gh 0
vnoremap gh 0
nnoremap gl $
vnoremap gl $
nnoremap gk gg
vnoremap gk gg
nnoremap gj G
vnoremap gj G

imap <C-L> <ESC>

nnor <leader>cf :let @+=expand("%:p")<CR>    " Mnemonic: Copy File path
nnor <leader>yf :let @"=expand("%:p")<CR>    " Mnemonic: Yank File path
nnor <leader>fn :let @"=expand("%")<CR>      " Mnemonic: yank File Name
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

nnoremap <leader>bs :buffers<CR>

nnoremap <leader>; :
nnoremap <leader>;e<leader> :e<CR>

nnoremap <leader>vs :vs<CR>
nnoremap <leader>maps :Maps<CR>
nnoremap <leader>sp :sp<CR>

nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>source :source ~/.vimrc<CR>
nnoremap <leader>srcthis :source %<cr>
nnoremap <leader>luathis :luafile %<cr>
