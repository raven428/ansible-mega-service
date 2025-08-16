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
export ANSIBLE_ROLES_PATH="/tmp/ansible/roles2test"
printf "\n\n\nmolecule [create] action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-0create" \
  ansible-docker.sh molecule -v create -s ${sce}
ANSIBLE_LOG_PATH="${LOG_PATH}-1converge" \
  ansible-docker.sh molecule -v converge -s ${sce}
# ANSIBLE_LOG_PATH="${LOG_PATH}-1converge" \
#   ansible-docker.sh molecule -v converge -s ${sce} -- -t service-gaiad,service-install
