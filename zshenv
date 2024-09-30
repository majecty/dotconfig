alias cac='cargo check'
alias fmt="cargo +nightly-2020-10-20 fmt"
alias clippy="cargo +stable clippy --all --all-targets"

source ~/.commonenv.sh
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
alias awesomeconf='KAKOUNE_SESSION=awesomeconf kak ~/jhconfig/awesomewm/rc.lua'

alias mic2speaker-on='pactl load-module module-loopback latency_msec=1'
alias mic2speaker-off='pactl unload-module module-loopback'
# eval "$(luarocks path)"
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export TAG_SEARCH_PROG=rg
export EDITOR=kak
export BAT_THEME=OneHalfLight

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

export GOPATH=`go env GOPATH`

if [[ -f ~/.haechi/env.sh ]]; then
  source ~/.haechi/env.sh
fi

# fbd - delete git branch (including remote branches)
fbd() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" | fzf --multi ) &&
  git branch -D $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

alias grupp="grup -p"
