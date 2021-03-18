#!/bin/bash

set -e
GITHUB_TOKEN="635bda25aecdfd9f8ae4ff461c4c169f0725293d"

# get the SHA to revert
COMMIT_TO_REVERT=$(git rev-parse HEAD)
# get this branch
HEAD_BRANCH=$(git branch --show-current)

git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
git config --global user.email "revert@github.com"
git config --global user.name "GitHub Revert Action"

set -o xtrace



git fetch origin $HEAD_BRANCH


#git checkout -b $HEAD_BRANCH origin/$HEAD_BRANCH

# check commit exists
git cat-file -t $COMMIT_TO_REVERT

# do the revert
git revert $COMMIT_TO_REVERT -m 1 --no-edit
# pass commit message in so we can identify what step failed

git commit --amend -m "$COMMIT_MESSAGE"
git push origin