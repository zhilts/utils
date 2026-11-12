#!/usr/bin/env bash
# git-set-author.sh — set user.email and/or user.name in every git repo
# under the current directory (node_modules is skipped).
#
# Usage: git-set-author.sh <email> [name]
#        git-set-author.sh "" <name>      # name only
#
# Writes the repo-local config (.git/config), not your global one.

EMAIL=$1
NAME=$2

if [[ -z "$EMAIL" && -z "$NAME" ]]; then
  echo "Usage: git-set-author.sh <email> [name]" >&2
  exit 1
fi

declare -a REPOS

while IFS= read -r repo; do
  REPOS+=("$repo")
done < <(find . -type d -name node_modules -prune -o -name .git -type d -print | sed 's/\/.git$//')

for REPO in "${REPOS[@]}"; do
  echo "Processing Git repository: $REPO"
  if [[ -n "$EMAIL" ]]; then
    echo "Set email $EMAIL"
    git -C "$REPO" config user.email "$EMAIL"
  fi
  if [[ -n "$NAME" ]]; then
    echo "Set name $NAME"
    git -C "$REPO" config user.name "$NAME"
  fi
done
