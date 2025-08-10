#!/usr/bin/env bash
set -ueo pipefail
umask 0022
MY_BIN="$(readlink -f "$0")"
MY_PATH="$(dirname "${MY_BIN}")"
cd "${MY_PATH}/../.."
# shellcheck disable=1091
source "${MY_PATH}/../prepare.sh"
sce='default'
LOG_PATH="/tmp/molecule-$(/usr/bin/env date '+%Y%m%d%H%M%S.%3N')"
printf "\n\n\nmolecule [create] action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-0create" \
  ansible-docker.sh molecule -v create -s "${sce}"
