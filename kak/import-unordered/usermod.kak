map global insert -docstring 'enter user mode' <c-k> '<esc>:enter-user-mode user<ret>'

map global user -docstring 'fzf-mode' f ':fzf-mode<ret>'
map global user -docstring 'lsp-mode' l ':enter-user-mode lsp<ret>'
map global user -docstring 'lsp hover' h ':lsp hover<ret>'
map global user -docstring 'format' o ':format<ret>'
map global user -docstring 'buffer' b ': enter-user-mode buffers<ret>'
map global user -docstring 'buffer' B ': enter-user-mode -lock buffers<ret>'
map global user -docstring 'filetype' <c-f> ':enter-user-mode filetype-mode<ret>'
map global user W '|fmt --width 80<ret>' -docstring "Wrap to 80 columns"

declare-user-mode path-mode
map global user -docstring 'path mode' a ':enter-user-mode path-mode<ret>'
map global path-mode -docstring 'move' m ':enter-user-mode path-move-mode<ret>'
map global path-mode -docstring 'print' p ':enter-user-mode path-print-mode<ret>'

declare-user-mode path-move-mode
map global path-move-mode -docstring 'cd to file parent' p ':cd %sh{dirname $kak_buffile}<ret>'

declare-user-mode path-print-mode
map global path-print-mode -docstring 'print current dir' c ':echo %sh{pwd}<ret>'
map global path-print-mode -docstring 'print file parent' p ':echo %sh{dirname $kak_buffile}<ret>'

declare-user-mode window-mode
map global normal -docstring 'window mode' <c-w> ':enter-user-mode window-mode<ret>'
map global insert -docstring 'window mode' <c-w> '<esc>:enter-user-mode window-mode<ret>'
map global window-mode -docstring 'exit' <c-q> ':quit<ret>'
map global window-mode -docstring 'exit' <c-Q> ':quit!<ret>'

declare-user-mode filetype-mode
map global filetype-mode -docstring 'highlight shell' s ':set buffer filetype sh<ret>'
map global filetype-mode -docstring 'highlight json' j ':set buffer filetype json<ret>'

declare-user-mode assistant
map global user -docstring 'ai mode' g ':enter-user-mode assistant<ret>'
map global assistant -docstring "Replace selection with code assistant's answer" r '<a-|>tee /tmp/kak-tmp-code.txt; echo "You are a code generator.\nWriting comments is forbidden.\nWriting test code is forbidden.\nWriting English explanations is forbidden.\nDont include general translations.\nContinue this $kak_bufname code:\n" > /tmp/kak-gpt-prompt.txt; cat /tmp/kak-tmp-code.txt >> /tmp/kak-gpt-prompt.txt<ret>| cat /tmp/kak-gpt-prompt.txt | chatgpt <ret>'
map global assistant -docstring "Commit message revise" c '<a-|>tee /tmp/kak-tmp-code.txt; echo "Please revise the commit message below.\nWriting English explanation is forbidden\nJust print commit message only\n$kak_bufname\n" > /tmp/kak-gpt-prompt.txt; cat /tmp/kak-tmp-code.txt >> /tmp/kak-gpt-prompt.txt<ret>| cat /tmp/kak-gpt-prompt.txt | chatgpt <ret>'


