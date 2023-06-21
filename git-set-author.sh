#!/usr/bin/env bash

EMAIL=$1
NAME=$2

declare -a REPOS

while IFS= read -r repo; do
  REPOS+=("$repo")
done < <(find . -type d -name node_modules -prune -o -name .git -type d -print | sed 's/\/.git//g')

# Loop over the repositories
for REPO in "${REPOS[@]}"; do
  echo "Processing Git repository: $REPO"
  if [[ -n "$EMAIL" ]]; then
    echo "Set email" $EMAIL
    git -C "$REPO" config user.email "$EMAIL"
  fi
  if [[ -n "$NAME" ]]; then
    echo "Set name" $NAME
    git -C "$REPO" config user.name "$NAME"
  fi

done