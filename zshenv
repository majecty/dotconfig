source ~/.commonenv.sh
eval `fnm env`

alias c='xclip -selection clipboard'
alias v='xclip -selection clipboard -o'

alias gcai='gt c --ai && gc!'
alias gppmain='git branch -f main && git push origin main'
alias gppmaster='git branch -f master && git push origin master'

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

gswai() {
  # Get today's date in YY-MM-DD format
  local today=$(date +%y-%m-%d)
  
  # Get the commit title and escape special characters
  local commit_title=$(git log -1 --pretty=%B | head -n1 | sed 's/[^a-zA-Z0-9]/-/g')
  
  # Create new branch name
  local new_branch="borre/${today}-${commit_title}"
  
  # Create and checkout new branch
  git checkout -b "$new_branch"
}


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

if [[ -f $HOME/.cargo/env ]]; then
  source $HOME/.cargo/env
fi

if [[ -d $HOME/.foundry/bin ]]; then
  export PATH="$PATH:$HOME/.foundry/bin"
fi

alias grupp="grup -p"
if [[ -f $HOME/jhconfig/secret.sh ]]; then
  source $HOME/jhconfig/secret.sh
fi

alias gcai='gt c --ai -v && gc!'
alias gppmain='gb -f main && gp origin main'
alias gppmaster='gb -f master && gp origin master'
alias gtsss='gt sync && gt ss -p'
alias gtsss_draft='gt sync && gt ss'
alias gtsc='gt sync'
alias gtcu='gt continue'
alias gai='git add -i'
alias gcni='git clean -i'
alias gtssp='gt ss -p'

alias ffmt='forge fmt'

gtrn() {
  local message=$(git log -1 --pretty=%B)
  gt rename "$message"
}

gswc-head() {
  local message=$(git log -1 --pretty=%B)
  # echo "$message"
  message=$(echo "$message" | sed 's/[^a-zA-Z0-9\s_-]/_/g')
  git switch -c "borre/$message"
}

bunr() {
  local script=$(jq -r '.scripts | to_entries[] | "\(.key) \(.value)"' package.json | fzf --prompt="Select bun script: " | awk '{print $1}')
  echo "$script"
  bun run "$script"
}


# bun completions
[ -s "/home/borre/.bun/_bun" ] && source "/home/borre/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$PATH:/home/borre/Applications/"


alias fzf-port='sudo lsof -i -P -n | fzf --header-lines=1 --multi --layout=reverse --height=50% --border'
alias fzf-port-netstat='sudo -ntlp | fzf --header-lines=1 --multi --layout=reverse --height=50% --border'


# for cursor ide https://github.com/getcursor/cursor/issues/549
[[ "$TERM_PROGRAM" == "vscode" ]] && unset ARGV0

export PERPLEXITY_API_KEY="pplx-"
