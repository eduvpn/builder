#!/bin/sh

PACKAGE_BRANCH=master
REPO_ROOT=${HOME}/repo/${PACKAGE_BRANCH}

# Create Archive
DATETIME=$(date +%Y%m%d%H%M%S)
cp ${HOME}/RPM-GPG-KEY-LC ${REPO_ROOT}/results/
cd "${REPO_ROOT}/results/" || exit 1
tar -cJf "${HOME}/rpmRepo-${PACKAGE_BRANCH}-${DATETIME}.tar.xz" .