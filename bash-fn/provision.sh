#!/bin/sh
set -euo pipefail

parse_params() {

  while :; do
    case "${1-}" in
    -n | --name)
      name="${2-}"
      shift
      ;;
    *) break ;;
    esac
    shift
  done

  # check required params and arguments
  [[ -z "${name-}" ]] && die "Missing required parameter: name"

  return 0
}

parse_params "$@"

TF_VAR_name=${name}
export TF_VAR_name

cd /home/app

terraform init -input=false

terraform apply -input=false -auto-approve
