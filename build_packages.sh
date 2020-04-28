#!/bin/bash

PACKAGE_BRANCH=v2
REPO_ROOT=${HOME}/repo/${PACKAGE_BRANCH}

# targets to build for
TARGET_LIST=(\
    epel-7-x86_64 \
    fedora-30-x86_64 \
    fedora-31-x86_64 \
    fedora-32-x86_64 \
)

# list of packages to build, *in this order*
PACKAGE_LIST=(\
    vpn-ca \
    vpn-daemon \
    php-fkooman-secookie \
    php-fkooman-saml-sp \
    php-saml-sp \
    php-saml-sp-artwork-eduVPN \
    php-fkooman-jwt \
    php-fkooman-otp-verifier \
    php-fkooman-oauth2-server \
    php-fkooman-sqlite-migrate \
    php-LC-openvpn-connection-manager \
    php-LC-common \
    vpn-server-api \
    vpn-server-node \
    vpn-user-portal \
    vpn-portal-artwork-eduVPN \
    vpn-portal-artwork-LC \
    php-json-signer \
    php-saml-ds \
    php-saml-ds-artwork-eduVPN \
)

# update the repositories with RPM spec files
for PACKAGE_NAME in "${PACKAGE_LIST[@]}"
do
    # if we already have the package git repository, simply update it
    if [ -d "${PACKAGE_NAME}" ]
    then
        (
            cd ${PACKAGE_NAME}
            git checkout ${PACKAGE_BRANCH}
            git pull origin ${PACKAGE_BRANCH}
        )
    else
        # otherwise, clone it
        git clone -b ${PACKAGE_BRANCH} https://git.tuxed.net/rpm/${PACKAGE_NAME}
    fi
done

for TARGET_NAME in "${TARGET_LIST[@]}"
do
    echo "**********************************************************"
    echo "* Building ${TARGET_NAME}..."
    echo "**********************************************************"

    # determine ARCH based on target name
    ARCH=$(echo ${TARGET_NAME} | cut -d '-' -f 3)

    SRPM_LIST=""

    # generate source RPMs for all the packages and add them to the list of 
    # packages that need to be (re)build
    for PACKAGE_NAME in "${PACKAGE_LIST[@]}"
    do
        # generate source RPM
        cp ${PACKAGE_NAME}/SOURCES/* ${HOME}/rpmbuild/SOURCES
        spectool -g -R ${PACKAGE_NAME}/SPECS/${PACKAGE_NAME}.spec
        SRPM_FILE=$(rpmbuild -bs "${PACKAGE_NAME}/SPECS/${PACKAGE_NAME}".spec | grep Wrote | cut -d ':' -f 2 | xargs)
        PACKAGE_NAME=$(basename "${SRPM_FILE}" .src.rpm)

        # check whether we already have a build of this exact version, if not,
        # add it to the list
        if [ ! -f "${REPO_ROOT}/results/${TARGET_NAME}/${PACKAGE_NAME}/success" ]
        then
            SRPM_LIST="${SRPM_LIST} ${SRPM_FILE}"
        fi
    done

    # only call mock when we have something to do...
    if [ "" = "${SRPM_LIST}" ]
    then
        echo "*** No (new) packages to build!"
        # continue with the next TARGET
        continue
    fi

    echo "**********************************************************"
    echo "* Building (${TARGET_NAME}): ${SRPM_LIST}..."
    echo "**********************************************************"
    mock --chain -r "${TARGET_NAME}" --localrepo="${REPO_ROOT}" --arch "${ARCH}" ${SRPM_LIST}

    # the mock "sign" plugin is broken
    # @see https://github.com/rpm-software-management/mock/issues/476

    # sign (all) packages
    rpmsign --addsign $(find ${REPO_ROOT}/results/${TARGET_NAME} -type f | grep \.rpm$ | xargs)
    # recreate the repository
    createrepo_c ${REPO_ROOT}/results/${TARGET_NAME}
done
