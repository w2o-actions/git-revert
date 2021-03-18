FROM alpine:latest

LABEL repository="https://github.com/w2o-actions/git-revert"
LABEL homepage="https://github.com/w2o-actions/git-revert"
LABEL "com.github.actions.name"="Git Revert"
LABEL "com.github.actions.description"="Automatically revert a commit"
LABEL "com.github.actions.icon"="git-pull-request"
LABEL "com.github.actions.color"="black"

RUN apk --no-cache add bash git

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]