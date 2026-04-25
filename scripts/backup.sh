#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-backups}"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"
ARCHIVE="$BACKUP_DIR/vaultwarden-data-$TIMESTAMP.tar.gz"
RESTART=false

mkdir -p "$BACKUP_DIR"

if docker compose ps --status running --services 2>/dev/null | grep -qx 'vaultwarden'; then
  RESTART=true
  docker compose stop vaultwarden
fi

cleanup() {
  if [ "$RESTART" = true ]; then
    docker compose start vaultwarden >/dev/null
  fi
}
trap cleanup EXIT

tar -czf "$ARCHIVE" data
printf 'Sauvegarde creee: %s\n' "$ARCHIVE"
