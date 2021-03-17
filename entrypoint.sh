#!/bin/bash

set -e
GITHUB_TOKEN="635bda25aecdfd9f8ae4ff461c4c169f0725293d"

# get the SHA to revert
COMMIT_TO_REVERT=$(git rev-parse HEAD)

git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
git config --global user.email "revert@github.com"
git config --global user.name "GitHub Revert Action"

set -o xtrace

git fetch origin $HEAD_BRANCH

# do the revert
git checkout -b $HEAD_BRANCH origin/$HEAD_BRANCH

# check commit exists
git cat-file -t $COMMIT_TO_REVERT
git revert $COMMIT_TO_REVERT -m 1 --no-edit
git push origin