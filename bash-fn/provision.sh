#!/bin/sh
set -euo pipefail

parse_params() {

  while :; do
    case "${1-}" in
    -n | --name)
      name="${2-}"
      shift
      ;;
    -k | --key) # example named parameter
      key="${2-}"
      shift
      ;;      
    *) break ;;
    esac
    shift
  done

  # check required params and arguments
  [[ -z "${key-}" ]] && die "Missing required parameter: key";
  [[ -z "${name-}" ]] && die "Missing required parameter: name";

  return 0
}

parse_params "$@"

SECRET_API_KEY=$(cat /var/openfaas/secrets/secret-api-key)
export SECRET_API_KEY

if [ "$key" = "$SECRET_API_KEY" ]; then
  echo "Keys are equal!"
else
  echo "Authentication failed"
  exit 1
fi

TF_VAR_name=${name}
export TF_VAR_name

cd /home/app

terraform init -input=false

terraform apply -input=false -auto-approve
