#!/usr/bin/env bash

if [ -z "$1" ]
 then
    BRANCH=origin/develop
 else
    BRANCH=$1
fi

COMMIT=$(git show --format=%H ${BRANCH})

git branch --merged | egrep -v "(^\*|master|develop|release|HEAD)" | xargs git branch -d
# push to remote
WEEK_AGO=$(python -c "from datetime import date, timedelta; print(date.today()-timedelta(days=7))")
git branch -r --format="${WEEK_AGO} %(committerdate:short) %(refname:short)" --merged | sed 's/origin\///g' | egrep -v "(^\*|master|develop|release|HEAD)" | awk '$1 > $2' | awk '{ print $3 }' | xargs git push origin --delete 
git prune
