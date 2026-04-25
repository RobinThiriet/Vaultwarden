#!/usr/bin/env bash
set -euo pipefail

PUID="${PUID:-1000}"
PGID="${PGID:-1000}"

mkdir -p data nginx/templates certbot/certs certbot/www secrets backups
chmod 700 secrets
chmod 750 data backups nginx certbot certbot/certs certbot/www

if [ "$(id -u)" -eq 0 ]; then
  chown -R "$PUID:$PGID" data backups
else
  chown -R "$PUID:$PGID" data backups 2>/dev/null || true
fi

printf 'Dossiers prepares. Renseigne .env puis lance ./scripts/generate-admin-token.sh\n'
