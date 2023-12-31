#!/usr/bin/bash

{
  set -e

  if [ -x /usr/bin/docker ]; then
    ENGINE=/usr/bin/docker
  elif [ -x /usr/bin/podman ]; then
    ENGINE=/usr/bin/podman
  else
    exit
  fi

  cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

  "${ENGINE}" compose --profile disabled pull --quiet
  "${ENGINE}" compose down

  /usr/bin/tar --create --file=update.tgz --gzip --verbose data-*/
  "${ENGINE}" compose run --rm --service-ports certbot

  "${ENGINE}" compose up --detach
} &> "${BASH_SOURCE[0]%.*}.log"
