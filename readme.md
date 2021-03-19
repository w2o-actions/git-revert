

## Purpose
This action was authored to support Git-Flow

The purpose of this action is to act as an automated "git revert" when a newly merged **feature** fails some tests ( vuln, integration, unit, etc.. )

This should only be triggered upon failure of something else.

*You can re-use this action in the same workflow, and provide a different "revert" commit message for that use case.*


## How to use

This is required
```
        with:
          fetch-depth: 0
```
NOTE: fetch depth gets more context required for revert

```
  Git-revert:
    runs-on: ubuntu-latest
    if: ${{ failure() }}
    steps:
      - name: Checkout latest code
        uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Automatic Revert
        uses: w2o-actions/git-revert@v1.0.0
        env:
          GITHUB_TOKEN: ${{ secrets.SA_PAT }}
          REPO_FULLNAME: ${{ github.repository}}
          REPO_OWNER: ${{ github.repository_owner }}
          COMMIT_MESSAGE: "Failed vulnerability scan"
```          