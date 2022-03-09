" Open FZF files
nnoremap <F1> :Maps<cr>
nnoremap <Leader>ff :Files<cr>
nnoremap <Leader>fd :FdDir<cr>
let g:fzf_preview_window = 'right:60%'
nnoremap <Leader>rg :RG<cr>
nnoremap <Leader>bb :Buffers<cr>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

function! FddirFzf(query, fullscreen)
  "let command_fmt = 'fd --type d %s || true'
  "let initial_command = printf(command_fmt, shellescape(a:query))
  "let reload_command = printf(command_fmt, '{q}')
  "let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  "call fzf#vim#grep(initial_command, 0, fzf#vim#with_preview(spec), a:fullscreen)
  call fzf#run(fzf#wrap({'sink': 'e', 'source': 'fd --type d'}, a:fullscreen))

  "call fzf#run(fzf#wrap({'sink': 'e', 'source': 'fd --type d',
    "\ 'left': '40%'}))
  "call fzf#vim#with_preview("directory", {'sink': 'e', 'source': 'fd --type d'})
endfunction

command! -nargs=* -bang FdDir call FddirFzf(<q-args>, <bang>0)

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
