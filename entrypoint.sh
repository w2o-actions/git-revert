#!/bin/bash

set -e

# get the SHA to revert
COMMIT_TO_REVERT=$(git rev-parse HEAD)
# get this branch
HEAD_BRANCH=$(git branch --show-current)

# get the branch that was just merged
MERGED_BRANCH=$(git log --merges origin/$HEAD_BRANCH --oneline --grep="^Merge pull request #\([0-9]\+\)" -1 | awk -F"$REPO_OWNER/" ' { print $NF } ')

# set git config
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
git config --global user.email "revert@github.com"
git config --global user.name "GitHub Revert Action"

set -o xtrace

git fetch origin $HEAD_BRANCH

# check commit exists
git cat-file -t $COMMIT_TO_REVERT

# do the revert
git revert $COMMIT_TO_REVERT -m 1 --no-edit
# pass commit message in so we can identify what step failed

git commit --amend -m "$COMMIT_MESSAGE"
git push origin


git fetch && git checkout $MERGED_BRANCH
git add -A
git commit -m "reset parent to revert commit -- due to $COMMIT_MESSAGE"
git push