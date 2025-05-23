# Highlight the word under the cursor
# ───────────────────────────────────

declare-option -hidden regex curword
set-face global CurWord default,rgb:4a4a4a

hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec <space><a-i>w <a-k>\A\w+\z<ret>
        set-option buffer curword "\b\Q%val{selection}\E\b"
    } catch %{
        set-option buffer curword ''
    } }
}

# add-highlighter global/ dynregex '%opt{curword}' 0:CurWord

map global normal '#' :comment-line<ret>

map global user -docstring 'next lint error' n ':lint-next-error<ret>'

# Enable <tab>/<s-tab> for insert completion selection
# ──────────────────────────────────────────────────────

hook global InsertCompletionShow .* %{ map window insert <tab> <c-n>; map window insert <s-tab> <c-p> }
hook global InsertCompletionHide .* %{ unmap window insert <tab> <c-n>; unmap window insert <s-tab> <c-p> }

define-command new-split "tmux-terminal-vertical kak -c %val{session}"
map global normal <c-n> ': new-split<ret>'
map global normal <c-v> ': new<ret>'

set-option global autoreload yes
set-option global grepcmd 'rg --column --with-filename'
set-option global tabstop 2
set-option global indentwidth 2

define-command scratch %{
      edit -scratch '*scratch*'
}

define-command scratch-reload %{
      edit! -scratch '*scratch*'
}

define-command find-edit -params 1 -shell-script-candidates 'fd --type file' %{
      edit %arg{1}
}

define-command find-edit-all -params 1 -shell-script-candidates 'fd --hidden --no-ignore --type file' %{
      edit %arg{1}
}

alias global s scratch
alias global s! scratch-reload

alias global f find-edit
alias global fa find-edit-all

# Rename buffers, clients and sessions
alias global nb rename-buffer
alias global nc rename-client
alias global ns rename-session

define-command delete-buffers-matching -params 1 %{
  evaluate-commands -buffer * %{
    evaluate-commands %sh{ case "$kak_buffile" in $1) echo delete-buffer ;; esac }
  }
}

map global normal <backspace> ';'

# Type <character><character> to leave insert mode.
# ["jj", "kk"]
hook global InsertChar '[jk]' %{
  try %{
    execute-keys -draft "hH<a-k>%val{hook_param}%val{hook_param}<ret>d"
    execute-keys <esc>
  }
}

addhl global/ wrap

define-command grey "colorscheme greyscale"
define-command source-this %{ source %val{buffile} }

define-command edit-debug %{
	tmux-terminal-vertical kak -c %val{session} -e "buffer *debug*"
}

define-command edit-jhconfig-config -params 1 -shell-script-candidates 'fd --type file . ~/jhconfig/kak' %{
  edit %arg{1}
}

define-command edit-kakoune-default-config -params 1 -shell-script-candidates 'fd --type file . ~/.local/share/kak/ ~/.config/kak/' %{
  edit %arg{1}
}

# addhl global/ show-whitespaces

map -docstring 'ignore case' global prompt <c-s> (?i)
map -docstring 'in line' global prompt <c-n> (?S)
map -docstring 'c-q to esc' global prompt <c-q> <esc>

map -docstring 'save' global normal <c-a-a> ':w<ret>'
map -docstring 'save' global insert <c-a-a> '<esc>:w<ret>'

map global insert <tab> '<a-;><gt>'
map global insert <s-tab> '<a-;><lt>'
