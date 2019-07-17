#!/usr/bin/env bash

if [ -z "$1" ]
 then
    BRANCH=origin/develop
 else
    BRANCH=$1
fi

COMMIT=$(git show --format=%H ${BRANCH})

git branch --merged | egrep -v "(^\*|master|develop|release)" | xargs git branch -d
# push to remote
# git branch -r --merged  | egrep -v "(^\*|master|develop|release)" | xargs echo  # git branch -d
git prune
