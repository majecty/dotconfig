alias cac='cargo check'
alias fmt="cargo +nightly-2020-10-20 fmt"
alias clippy="cargo +stable clippy --all --all-targets"

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
export PATH=$HOME/.fnm:$PATH
export PATH=$PATH:$HOME/.emacs.d/bin
export PATH=$PATH:$HOME/.config/rofi/bin
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
alias sshconfig='KAKOUNE_SESSION=sshconfig kak ~/.ssh/config'

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
export GTK_IM_MODULE=ibus
export GLFW_IM_MODULE=ibus

alias tl="tmuxlayout"
alias tasd="tmuxlayout asd"
alias tasdf="tmuxlayout asdf"
alias tnew="tmux new -s"
# alias tnewdir="tmux new -s `pwd`"

tnewdir()
{
  DIR=$(pwd)
  BASE=$(basename $DIR)
  BASE2=$(echo $BASE | sed --expression "s/\./_/g")
  tnew $BASE2
}
