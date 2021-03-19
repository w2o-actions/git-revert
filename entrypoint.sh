#!/bin/bash

set -e
set -o xtrace

set git config
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
git config --global user.email "revert@github.com"
git config --global user.name "GitHub Revert Action"

# get this branch
HEAD_BRANCH=$(git branch --show-current)



git fetch origin $HEAD_BRANCH

git checkout $HEAD_BRANCH

# get the SHA to revert
COMMIT_TO_REVERT=$(git rev-parse HEAD)


# check commit exists
git cat-file -t $COMMIT_TO_REVERT

# do the revert
git revert $COMMIT_TO_REVERT -m 1 --no-edit
# pass commit message in so we can identify what step failed

git commit --amend -m "$COMMIT_MESSAGE"
git push -u origin $HEAD_BRANCH
sleep 3
# get the branch that was just merged

MERGED_BRANCH=$(git log --merges origin/$HEAD_BRANCH --oneline -1 | awk -F"$REPO_OWNER/" ' { print $NF } ' )
#GIT_LOG_TEST=$(git log --merges origin/$HEAD_BRANCH --oneline)

git fetch
git checkout $MERGED_BRANCH

COMMIT_TO_CHERRY_PICK=$(git rev-parse HEAD)
git pull origin $HEAD_BRANCH
git cherry-pick $COMMIT_TO_CHERRY_PICK
sleep 2
git add -A --quiet
git commit -m "reset parent to revert commit -- due to $COMMIT_MESSAGE" --quiet
date;
git push ;
sleep 3;
git push -u origin $MERGED_BRANCH;
sleep 10;
echo "Push should happen above me"
