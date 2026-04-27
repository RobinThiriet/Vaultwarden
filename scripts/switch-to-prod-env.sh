#!/usr/bin/env bash
set -euo pipefail

SOURCE_FILE=".env.example"
TARGET_FILE=".env"
TIMESTAMP="$(date -u +%Y%m%dT%H%M%SZ)"

if [ ! -f "$SOURCE_FILE" ]; then
  printf 'Fichier %s introuvable.\n' "$SOURCE_FILE" >&2
  exit 1
fi

if [ -f "$TARGET_FILE" ]; then
  BACKUP_FILE=".env.backup-$TIMESTAMP"
  cp "$TARGET_FILE" "$BACKUP_FILE"
  printf 'Sauvegarde de %s dans %s\n' "$TARGET_FILE" "$BACKUP_FILE"
fi

cp "$SOURCE_FILE" "$TARGET_FILE"

printf '.env de production cree depuis %s\n' "$SOURCE_FILE"
printf 'Edite maintenant les variables suivantes:\n'
printf '  DOMAIN=https://vaultwarden.mondomaine.fr\n'
printf '  NGINX_HOST=vaultwarden.mondomaine.fr\n'
printf '  ACME_EMAIL=robin@mondomaine.fr\n'
