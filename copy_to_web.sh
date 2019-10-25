#!/bin/sh

PACKAGE_BRANCH=v2
#PACKAGE_BRANCH=master
REPO_ROOT=${HOME}/repo-${PACKAGE_BRANCH}
WEB_ROOT=/var/www/html

mkdir -p ${WEB_ROOT}/repo-${PACKAGE_BRANCH}
cp ${HOME}/RPM-GPG-KEY-LC ${WEB_ROOT}/repo-${PACKAGE_BRANCH}/
cp -r ${REPO_ROOT}/results/* ${WEB_ROOT}/repo-${PACKAGE_BRANCH}/
restorecon -R ${WEB_ROOT}/repo-${PACKAGE_BRANCH}