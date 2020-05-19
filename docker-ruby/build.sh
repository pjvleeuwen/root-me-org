#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
docker stop ruby-root-me-org-container
docker rm ruby-root-me-org-container
docker build -t ruby-root-me-org "$DIR"
docker run --detach --name ruby-root-me-org-container -v "$DIR/../":/usr/src/app ruby-root-me-org

