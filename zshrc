# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME"/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="funky"
#ZSH_THEME="lambda"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions alias-finder yarn gitfast alias-tips fzf-alias ubuntu)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#. /usr/share/autojump/autojump.sh

# source /usr/share/doc/fzf/examples/key-bindings.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# coppied from https://www.reddit.com/r/emacs/comments/9b1bhs/emacsshell_protip_alias_magit/
alias magit='emacsclient -nw -a emacs -e "(magit-status \"$(git rev-parse --show-toplevel)\")"'

alias cac='cargo check'
export EDITOR=kak

export ZSH_ALIAS_FINDER_AUTOMATIC=true

alias vim=nvim
alias tmux="TERM=xterm-256color tmux"

export DENO_INSTALL=$HOME"/.deno"

alias update-copyright="git diff --name-only HEAD^ | xargs -L 1 deno --allow-read --allow-write ~/bin/copyright.ts"
alias vimdiff='nvim -d'

mkcdir ()
{
    mkdir -p -- "$1" &&
      cd -P -- "$1"
}

alias rust-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src majecty/rust-musl-cross:aarch64-musl'
alias rust-musl-build='rust-musl-builder cargo rustc -- -C link-arg=-lgcc'
alias rust-musl-build-release='rust-musl-builder cargo rustc --release -- -C link-arg=-lgcc'


_fzf_complete_git() {
    ARGS="$@"

    # these are commands I commonly call on commit hashes.
    # cp->cherry-pick, co->checkout

    if [[ $ARGS == 'git cp'* || \
          $ARGS == 'git cherry-pick'* || \
          $ARGS == 'git co'* || \
          $ARGS == 'git checkout'* || \
          $ARGS == 'git reset'* ]]; then
        _fzf_complete "--reverse --multi" "$@" < <(
            git log \
                --graph \
                --abbrev-commit \
                --decorate \
                --all \
                --date=short \
                --format=format:'%C(bold blue)%h%C(reset) %C(bold cyan)%ad%C(reset) | %C(white)%s%C(reset) %C(dim green)[%an]%C(reset) %C(bold yellow)%d%C(reset)'
        )
    else
        eval "zle ${fzf_default_completion:-expand-or-complete}"
    fi
}

_fzf_complete_git_post() {
    sed -e 's/^[^a-z0-9]*//' | awk '{print $1}'
}

if (( $+commands[tag] )); then
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
fi

export TAG_CMD_FMT_STRING="kak {{.Filename}} +{{.LineNumber}}:{{.ColumnNumber}}"
# For the kak
export PATH=$HOME/.local/bin:$PATH

# export PAGER=kak
# export MANPAGER=kak-man-pager
alias kak-debug="kak -e edit-debug"

export STARSHIP_CONFIG=~/jhconfig/starship.toml
eval $(starship init zsh)

source ~/perl5/perlbrew/etc/bashrc
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

# Environment variables
export KAKOUNE_SESSION=kakoune

# Functions
kamux() {
  KAKOUNE_SESSION=$(tmux display-message -p '#{session_name}' | sed --expression "s/\//_/g") \
  kak-wrapper "$@"
}

ka.() {
  KAKOUNE_SESSION=$(pwd | sed --expression "s/\//_/g") \
  kak-wrapper "$@"
}

kanew() {
  KAKOUNE_SESSION=$(print-random.lua | sed --expression "s/\.//g") \
  kak-wrapper "$@"
}

# Aliases
#alias kak=kak-wrapper

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export PATH="$PATH:/home/juhyung/.cask/bin"
export PATH="$PATH:/home/juhyung/bin/graalvm-ce-java11-20.3.0/bin"

alias ta='tmux a -t $(tmux ls -F "#{session_name}" | fzf)'
alias cdf='cd `ls | fzf`'

source $HOME/bin/git-subrepo/.rc
