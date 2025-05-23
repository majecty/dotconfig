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
plugins=(git zsh-autosuggestions alias-finder yarn gitfast alias-tips fzf-alias ubuntu  docker-compose common-aliases archlinux  emacs)

source $ZSH/oh-my-zsh.sh

for file in $ZSH_CONFIG/**/*.sh;
do
    source $file
done


# User configuration


# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# coppied from https://www.reddit.com/r/emacs/comments/9b1bhs/emacsshell_protip_alias_magit/

export ZSH_ALIAS_FINDER_AUTOMATIC=true

alias magit='emacsclient -nw -a emacs -e "(magit-status \"$(git rev-parse --show-toplevel)\")"'
alias cac='cargo check'
export EDITOR=kak
alias vim=nvim
alias vimdiff='nvim -d'
alias cdf='cd `ls | fzf`'
# source /home/juhyung/.config/broot/launcher/bash/br
export STARSHIP_CONFIG=~/jhconfig/starship.toml
eval $(starship init zsh)

export DENO_INSTALL=$HOME"/.deno"


# Aliases
#alias kak=kak-wrapper

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/borre/.sdkman"
[[ -s "/home/borre/.sdkman/bin/sdkman-init.sh" ]] && source "/home/borre/.sdkman/bin/sdkman-init.sh"

eval "$(fnm env --use-on-cd --shell zsh)"
source <(kubectl completion zsh)

eval "$(zoxide init zsh)"
eval "$(gt completion)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/borre/bin/gcloud/google-cloud-sdk/path.zsh.inc' ]; then . '/home/borre/bin/gcloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/borre/bin/gcloud/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/borre/bin/gcloud/google-cloud-sdk/completion.zsh.inc'; fi



[[ -s "/home/borre/.gvm/scripts/gvm" ]] && source "/home/borre/.gvm/scripts/gvm"

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# pnpm
export PNPM_HOME="/home/borre/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias ass='gt show'
alias asd='gt delete'
alias asc='gt co'

# bun completions
[ -s "/home/borre/.bun/_bun" ] && source "/home/borre/.bun/_bun"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/borre/.lmstudio/bin"
