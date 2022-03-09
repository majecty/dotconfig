alias tmux="TERM=xterm-256color tmux"
alias ta='tmux a -t $(tmux ls -F "#{session_name}" | fzf)'
