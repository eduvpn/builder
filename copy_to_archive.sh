#!/bin/sh

PACKAGE_BRANCH=v2
#PACKAGE_BRANCH=master
REPO_ROOT=${HOME}/repo-${PACKAGE_BRANCH}

# Create Archive
DATETIME=$(date +%Y%m%d%H%M%S)
(
    cd "${REPO_ROOT}" || exit 1
    tar -cJf "${HOME}/rpmRepo-${PACKAGE_BRANCH}-${DATETIME}.tar.xz" .
)