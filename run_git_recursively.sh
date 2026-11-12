#!/usr/bin/env bash
# run_git_recursively.sh — run a shell command inside every git repo under
# the current directory (node_modules is skipped).
#
# Usage: run_git_recursively.sh <command...>
#
# Examples:
#   run_git_recursively.sh git pull
#   run_git_recursively.sh 'git status -sb && git stash list'
#
# The command goes through eval, so quote it to keep && and pipes together.
# nvm is loaded first so node/npm commands work.

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if [ "$#" -eq 0 ]; then
    echo "Usage: run_git_recursively.sh <command...>" >&2
    exit 1
fi

COMMAND="$*"

run_command_in_repo() {
    local repo_dir="$1"
    pushd "$repo_dir" > /dev/null || return
    echo "Running command in repository: $repo_dir"
    # stdin is closed so the command can't swallow the list of repos below
    eval "$COMMAND" < /dev/null
    echo "Command completed in $repo_dir"
    popd > /dev/null || return
}

find . -type d -name "node_modules" -prune -o -type d -name ".git" -print | while read -r gitdir; do
    repo_dir=$(dirname "$gitdir")
    echo "Processing repository: $repo_dir"
    run_command_in_repo "$repo_dir"
    echo ""
done
