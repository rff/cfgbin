#!/bin/bash

# FIXME: Taken from stakoverflow, need to find the link again.

FULL_NAME="$1"
EMAIL="$2"
REV_LIST="${3:-''}"

if [ "${FULL_NAME}" == "" -o  "${EMAIL}" == "" ] ; then
    echo "format: cmd <full name> <email> [rev-list]"
    exit 1
fi

git filter-branch -f --commit-filter "           \
    export GIT_AUTHOR_NAME=\"${FULL_NAME}\"    ; \
    export GIT_COMMITTER_NAME=\"${FULL_NAME}\" ; \
    export GIT_AUTHOR_EMAIL=${EMAIL}           ; \
    export GIT_COMMITTER_EMAIL=${EMAIL}        ; \
    git commit-tree \"\$@\" " -- ${REV_LIST}

