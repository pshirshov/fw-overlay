#!/bin/bash

DIR="$(
    dirname "$(readlink -f "$0")"
)"

cd "${DIR}"

CACHE_DIR="${DIR}/metadata/md5-cache"
REPO_NAME="$(cat ${DIR}/profiles/repo_name)"

CONFIG=$(cat << EOF
    [DEFAULT]
    main-repo=gentoo

    [gentoo]
    location = /usr/portage

    [${REPO_NAME}]
    location=$(pwd)
EOF
)

# tmp cache in /var/tmp to not to require root privileges
# also this dir is not removed because it can drastically
# improve egencache performance
TMP_CACHE="/tmp/${REPO_NAME}-cache"

mkdir -p "${TMP_CACHE}"
[[ -d ${CACHE_DIR} ]] && rm -rf ${CACHE_DIR}
egencache \
    --repositories-configuration="${CONFIG}" \
    --cache-dir="${TMP_CACHE}" \
    --repo="${REPO_NAME}" \
    --update \
    --update-manifests

#rm -rf "${TMP_CACHE}"
