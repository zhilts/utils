#!/bin/sh
# git-find-blob.sh — list the commits whose tree contains a given blob.
#
# Usage: git-find-blob.sh <blob-sha> [git log options]
#
# Pair it with git-find-large-files.sh: take a SHA from its output to see
# which commits carry that big file. Extra arguments go to git log,
# e.g. `git-find-blob.sh 3f2a9c1 --all`.

if [ -z "$1" ]; then
    echo "Usage: git-find-blob.sh <blob-sha> [git log options]" >&2
    exit 1
fi

obj_name="$1"
shift
git log "$@" --pretty=format:'%T %h %s' \
| while read -r tree commit subject ; do
    if git ls-tree -r "$tree" | grep -q "$obj_name" ; then
        echo "$commit" "$subject"
    fi
done
