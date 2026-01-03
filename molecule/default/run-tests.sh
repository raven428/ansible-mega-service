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
ANSIBLE_LOG_PATH="${LOG_PATH}-00create" \
  ansible-docker.sh molecule -v create -s ${sce}
n=1
run_group() {
  local tag="${1}"
  local last="${tag:-}"
  local prefix="${last##*-}"
  [[ -n "${prefix}" ]] && prefix="-${prefix}"
  [[ "${tag}" != '' && "${last##*,}" != 'all' ]] && {
    printf "\n\n\nmolecule [converge] %s check\n" "${tag}"
    ANSIBLE_LOG_PATH="${LOG_PATH}-$(printf %02d $n)converge${prefix}-check" \
      ansible-docker.sh molecule -v converge -s "${sce}" -- --check -t "$tag"
    ((n++))
  }
  for mode in action check; do
    args=''
    if [[ "${mode}" == 'check' ]]; then
      if [[ -z "${tag:-}" ]]; then
        args=" -- --check"
      else
        args=" -- -t ${tag} --check"
      fi
    elif [[ -n "${tag:-}" ]]; then
      args=" -- -t $tag"
    fi
    for stage in converge idempotence; do
      printf "\n\n\nmolecule [%s] %s %s\n" "${stage}" "${mode}" "${tag}"
      # shellcheck disable=2086
      ANSIBLE_LOG_PATH="${LOG_PATH}-$(printf %02d $n)${stage}${prefix}-${mode}" \
        ansible-docker.sh molecule -v "${stage}" -s "${sce}"${args}
      ((n++))
    done
  done
}
run_group '' ''
run_group "service-gaiad,service-start"
run_group "service-gaiad,service-stop"
run_group "service-gaiad,service-destroy"
printf "\n\n\nmolecule [recreate] all-start\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-$(printf %02d "$n")destroy2recreate" \
  ansible-docker.sh molecule -v destroy -s ${sce}
((n++))
ANSIBLE_LOG_PATH="${LOG_PATH}-$(printf %02d "$n")recreate4all-start" \
  ansible-docker.sh molecule -v create -s ${sce}
((n++))
run_group "service-gaiad,service-start,all"
printf "\n\n\nmolecule [converge] service-destroy fail\n"
ANSIBLE_PROP_MODE='fail-destroy' \
  ANSIBLE_LOG_PATH="${LOG_PATH}-$(printf '%02d' "$n")converge-destroy" \
  ansible-docker.sh molecule -v converge -s "${sce}" -- -t service-gaiad,service-destroy
((n++))
export ANSIBLE_PROP_MODE='systemd'
run_group "service-gaiad,service-stop"
run_group "service-gaiad,service-start"
export ANSIBLE_PROP_MODE='none'
run_group "service-gaiad,service-reset"
export ANSIBLE_PROP_MODE='fail-stop'
run_group "service-gaiad,service-stop"
