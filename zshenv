alias cac='cargo check'
alias fmt="cargo +nightly-2020-05-05 fmt"
alias clippy="cargo +nightly-2020-05-05 clippy --all --all-targets"

alias cc-22x-fmt='cargo +nightly-2019-10-13 fmt'
alias cc-22x-clippy='cargo +nightly-2019-10-13 clippy --all --all-targets'

alias cc-master-fmt='cargo +nightly-2019-12-19 fmt'
alias cc-master-clippy='cargo +nightly-2019-12-19 clippy --all --all-targets'
export PATH=$HOME/.local/bin:$PATH
export PATH=$PATH:/home/juhyung/bin
export PATH=$PATH:~/.cargo/bin/
export PATH=$PATH:~/bin
export PATH=$PATH:~/.yarn/bin/
export PATH=$PATH:$HOME/.config/yarn/global
export PATH=$PATH:~/bin/dynalist-1.0.5
export PATH=$PATH:/snap/bin/
export PATH=$PATH:$HOME/bin/firefox
export PATH="$DENO_INSTALL/bin:$PATH"
export PATH=$PATH:$HOME/.nvm/versions/node/v13.12.0/bin
export PATH=$PATH:$HOME/bin/go/bin
# fnm
export PATH=/home/juhyung/.fnm:$PATH
# eval "`fnm env --multi`"
eval `fnm env`

alias c='xclip -selection clipboard'
alias v='xclip -selection clipboard -o'

alias tmuxc='tmux loadb -'
alias tmuxv='tmux saveb -'

alias kakrc='KAKOUNE_SESSION=kakrc kak ~/jhconfig/kak/kakrc'
alias zshrc='KAKOUNE_SESSION=zshrc kak ~/jhconfig/zshrc'
alias zshenv='KAKOUNE_SESSION=zhenv kak ~/jhconfig/zshenv'
alias tmuxconf='KAKOUNE_SESSION=tmuxconf kak ~/jhconfig/tmux.conf'
alias mic2speaker-on='pactl load-module module-loopback latency_msec=1'
alias mic2speaker-off='pactl unload-module module-loopback'
eval "$(luarocks path)"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export TAG_SEARCH_PROG=rg
export PATH=$PATH:~/go/bin
export EDITOR=kak
export PATH=$PATH:$HOME/perl5/bin
export BAT_THEME=OneHalfLight
export PATH=$PATH:~/jhconfig/bin
export PATH=$PATH:~/jhconfig/lua
