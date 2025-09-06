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

# tags: no,all/implicit
printf "\n\n\nmolecule [converge] action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-02converge" ansible-docker.sh molecule \
  -v converge -s ${sce}
printf "\n\n\nmolecule [idempotence] action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-03idempotence" ansible-docker.sh molecule \
  -v idempotence -s ${sce}
printf "\n\n\nmolecule [converge] check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-04converge-check" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check
printf "\n\n\nmolecule [idempotence] check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-05idempotence-check" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- --check

# tags: service-gaiad,service-start
printf "\n\n\nmolecule [converge] service-start check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-06converge-check-start" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-start
printf "\n\n\nmolecule [converge] service-start action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-07converge-start" ansible-docker.sh molecule \
  -v converge -s ${sce} -- -t service-gaiad,service-start
printf "\n\n\nmolecule [idempotence] service-start action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-08idempotence-start" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- -t service-gaiad,service-start
printf "\n\n\nmolecule [converge] service-start check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-09converge-check-start" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-start
printf "\n\n\nmolecule [idempotence] service-start check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-10idempotence-check-start" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- --check -t service-gaiad,service-start

# tags: service-gaiad,service-stop
printf "\n\n\nmolecule [converge] service-stop check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-11converge-check-stop" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-stop
printf "\n\n\nmolecule [converge] service-stop action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-12converge-stop" ansible-docker.sh molecule \
  -v converge -s ${sce} -- -t service-gaiad,service-stop
printf "\n\n\nmolecule [idempotence] service-stop action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-13idempotence-stop" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- -t service-gaiad,service-stop
printf "\n\n\nmolecule [converge] service-stop check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-14converge-check-stop" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-stop
printf "\n\n\nmolecule [idempotence] service-stop check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-15idempotence-check-stop" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- --check -t service-gaiad,service-stop

# tags: service-gaiad,service-destroy (remove w/o stop)
printf "\n\n\nmolecule [converge] service-destroy check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-16converge-destroy" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-destroy
printf "\n\n\nmolecule [converge] service-destroy action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-17converge-destroy" ansible-docker.sh molecule \
  -v converge -s ${sce} -- -t service-gaiad,service-destroy
printf "\n\n\nmolecule [idempotence] service-destroy action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-18idempotence-destroy" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- -t service-gaiad,service-destroy
printf "\n\n\nmolecule [converge] service-destroy check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-19converge-destroy" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-destroy
printf "\n\n\nmolecule [idempotence] service-destroy check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-20converge-destroy" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- --check -t service-gaiad,service-destroy

# tags: all,service-gaiad,service-start
printf "\n\n\nmolecule [converge] all-start recreate\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-21destroy" \
  ansible-docker.sh molecule -v destroy -s ${sce}
ANSIBLE_LOG_PATH="${LOG_PATH}-21create" \
  ansible-docker.sh molecule -v create -s ${sce}
printf "\n\n\nmolecule [converge] all-start action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-22converge-all-start" ansible-docker.sh molecule \
  -v converge -s ${sce} -- -t all,service-gaiad,service-start
printf "\n\n\nmolecule [idempotence] all-start action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-23idempotence-all-start" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- -t all,service-gaiad,service-start
printf "\n\n\nmolecule [converge] all-start check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-24converge-all-start" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t all,service-gaiad,service-start
printf "\n\n\nmolecule [idempotence] all-start check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-25idempotence-all-start" ansible-docker.sh molecule \
 -v idempotence -s ${sce} -- --check -t all,service-gaiad,service-start

# tags: service-gaiad,service-destroy w/o stop
export ANSIBLE_PROP_MODE='fail-destroy'
printf "\n\n\nmolecule [converge] service-destroy action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-26converge-destroy" ansible-docker.sh molecule \
  -v converge -s ${sce} -- -t service-gaiad,service-destroy

# tags: service-gaiad,service-reset (remove w/stop)
printf "\n\n\nmolecule [converge] service-reset check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-26converge-reset" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-reset
printf "\n\n\nmolecule [converge] service-reset action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-27converge-reset" ansible-docker.sh molecule \
  -v converge -s ${sce} -- -t service-gaiad,service-reset
printf "\n\n\nmolecule [idempotence] service-reset action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-28idempotence-reset" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- -t service-gaiad,service-reset
printf "\n\n\nmolecule [converge] service-reset check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-29converge-reset" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-reset
printf "\n\n\nmolecule [idempotence] service-reset check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-30converge-reset" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- --check -t service-gaiad,service-reset

# tags: service-gaiad,service-stop w/no unit
export ANSIBLE_PROP_MODE='fail-stop'
printf "\n\n\nmolecule [converge] service-stop check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-31converge-stop" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-stop
printf "\n\n\nmolecule [converge] service-stop action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-32converge-stop" ansible-docker.sh molecule \
  -v converge -s ${sce} -- -t service-gaiad,service-stop
printf "\n\n\nmolecule [idempotence] service-stop action\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-33idempotence-stop" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- -t service-gaiad,service-stop
printf "\n\n\nmolecule [converge] service-stop check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-34converge-stop" ansible-docker.sh molecule \
  -v converge -s ${sce} -- --check -t service-gaiad,service-stop
printf "\n\n\nmolecule [idempotence] service-stop check\n"
ANSIBLE_LOG_PATH="${LOG_PATH}-35converge-stop" ansible-docker.sh molecule \
  -v idempotence -s ${sce} -- --check -t service-gaiad,service-stop
