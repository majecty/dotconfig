
if (( $+commands[tag] )); then
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
fi
export TAG_CMD_FMT_STRING="kak {{.Filename}} +{{.LineNumber}}:{{.ColumnNumber}}"
alias kak-debug="kak -e edit-debug"

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

