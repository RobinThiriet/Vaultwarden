#!/usr/bin/env bash
set -euo pipefail

if [ ! -f .env ]; then
  printf 'Fichier .env introuvable. Lance: cp .env.example .env puis edite-le.\n' >&2
  exit 1
fi

set -a
# shellcheck disable=SC1091
. ./.env
set +a

: "${NGINX_HOST:?NGINX_HOST doit etre defini dans .env}"
: "${ACME_EMAIL:?ACME_EMAIL doit etre defini dans .env}"

LIVE_DIR="certbot/certs/live/$NGINX_HOST"
mkdir -p "$LIVE_DIR" certbot/www

if [ ! -f "$LIVE_DIR/fullchain.pem" ] || [ ! -f "$LIVE_DIR/privkey.pem" ]; then
  printf 'Creation du certificat temporaire pour demarrer Nginx...\n'
  openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
    -keyout "$LIVE_DIR/privkey.pem" \
    -out "$LIVE_DIR/fullchain.pem" \
    -subj "/CN=$NGINX_HOST" >/dev/null 2>&1
fi

docker compose up -d nginx

printf "Demande du certificat Let's Encrypt pour %s...\n" "$NGINX_HOST"
docker compose run --rm --entrypoint certbot certbot certonly \
  --webroot \
  --webroot-path /var/www/certbot \
  --email "$ACME_EMAIL" \
  --agree-tos \
  --no-eff-email \
  --force-renewal \
  -d "$NGINX_HOST"

docker compose exec nginx nginx -s reload
printf 'Certificat installe. Pense a planifier le renouvellement: ./scripts/renew-certs.sh\n'
