alias cac='cargo check'
alias fmt="cargo +nightly-2020-05-05 fmt"
alias clippy="cargo +nightly-2020-05-05 clippy --all --all-targets"

alias cc-22x-fmt='cargo +nightly-2019-10-13 fmt'
alias cc-22x-clippy='cargo +nightly-2019-10-13 clippy --all --all-targets'

alias cc-master-fmt='cargo +nightly-2019-12-19 fmt'
alias cc-master-clippy='cargo +nightly-2019-12-19 clippy --all --all-targets'
export PATH=$PATH:/home/juhyung/bin
export PATH=$PATH:$HOME/.local/bin
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
eval "`fnm env --multi`"

alias c='xclip -selection clipboard'
alias v='xclip -selection clipboard -o'
alias kakrc='kak -s kakrc ~/jhconfig/kak/kakrc'
alias zshrc='kak -s zshrc ~/jhconfig/zshrc'
alias zshenv='kak -s zshenv ~/jhconfig/zshenv'
alias mic2speaker-on='pactl load-module module-loopback latency_msec=1'
alias mic2speaker-off='pactl unload-module module-loopback'
