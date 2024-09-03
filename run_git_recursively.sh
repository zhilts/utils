#!/usr/bin/env bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Check if a command was provided
if [ "$#" -eq 0 ]; then
    echo "Usage: run_in_git_repos.sh <command>"
    exit 1
fi

# Get the command to run
COMMAND="$@"

# Function to run a command in a Git repository
run_command_in_repo() {
    local repo_dir="$1"

    # Navigate to the repository directory
    pushd "$repo_dir" || return

    echo "Running command in repository: $repo_dir"

    # Run the command
    eval "$COMMAND"

    echo "Command completed in $repo_dir"
    popd
}

export -f run_command_in_repo

# Find all .git directories while excluding node_modules
find . -type d -name "node_modules" -prune -o -type d -name ".git" -print | while read -r gitdir; do
    repo_dir=$(dirname "$gitdir")
    echo "Processing repository: $repo_dir"
    run_command_in_repo "$repo_dir"
    echo ""
done
