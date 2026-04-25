#!/usr/bin/env bash
set -euo pipefail

IMAGE="${VAULTWARDEN_IMAGE:-vaultwarden/server:1.35.7-alpine}"
SECRET_FILE="${ADMIN_TOKEN_FILE:-./secrets/admin_token}"

mkdir -p "$(dirname "$SECRET_FILE")"
chmod 700 "$(dirname "$SECRET_FILE")"

if ! command -v docker >/dev/null 2>&1; then
  printf 'Docker est requis pour generer le hash Argon2 avec Vaultwarden.\n' >&2
  exit 1
fi

printf 'Vaultwarden va demander deux fois le mot de passe admin.\n'
printf 'Copie ensuite la ligne qui commence par "$argon2id$" et colle-la ici.\n\n'

docker run --rm -it "$IMAGE" /vaultwarden hash

printf '\nColle le hash Argon2 complet: '
IFS= read -r TOKEN

case "$TOKEN" in
  '$argon2id$'*)
    printf '%s\n' "$TOKEN" > "$SECRET_FILE"
    chmod 600 "$SECRET_FILE"
    printf 'Token admin enregistre dans %s\n' "$SECRET_FILE"
    ;;
  *)
    printf 'Valeur refusee: le token doit commencer par "$argon2id$".\n' >&2
    exit 1
    ;;
esac
