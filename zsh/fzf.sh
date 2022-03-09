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

