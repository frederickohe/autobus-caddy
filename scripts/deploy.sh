#!/usr/bin/env bash
# Caddy control station — reload proxy without tearing down app stacks.
set -euo pipefail

BRANCH="${DEPLOY_BRANCH:-main}"

ensure_network() {
  if ! docker network inspect caddy >/dev/null 2>&1; then
    docker network create caddy
  fi
}

ensure_network

git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

docker compose pull
docker compose up -d --remove-orphans
docker image prune -f

docker compose ps
