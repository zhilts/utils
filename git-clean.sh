#!/usr/bin/env bash
# git-clean.sh — delete branches that are already merged.
#
# Usage: git-clean.sh [-r]
#
#   (no flag)  git fetch --prune, then delete local branches merged into HEAD.
#   -r         also delete branches on origin that are merged into HEAD and
#              whose last commit is older than 30 days.
#
# Never deleted: the current branch, main, master, develop, dev, staging, release*.
# Run it from the branch everything merges into (usually main).

KEEP='^(main|master|develop|dev|staging|release.*|HEAD)$'

REMOTE=false
for arg in "$@"; do
    [ "$arg" = "-r" ] && REMOTE=true
done

git fetch --prune

CURRENT=$(git branch --show-current)
git branch --format='%(refname:short)' --merged \
    | grep -Ev "$KEEP" \
    | grep -vxF "$CURRENT" \
    | xargs git branch -d

if $REMOTE; then
    echo "Deleting old merged branches on origin"
    CUTOFF=$(date -v-30d +%F 2>/dev/null || date -d '30 days ago' +%F)
    git for-each-ref --merged HEAD --format='%(committerdate:short) %(refname:lstrip=3)' refs/remotes/origin \
        | awk -v cutoff="$CUTOFF" '$1 < cutoff { print $2 }' \
        | grep -Ev "$KEEP" \
        | xargs git push origin --delete
    git prune
else
    echo "Skipping remote (pass -r to clean origin too)"
fi
