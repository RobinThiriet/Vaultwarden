# Vaultwarden Docker

Deploiement Vaultwarden securise avec Docker Compose et Caddy.

## Ce qui est active

- HTTPS automatique via Caddy et Let's Encrypt.
- Vaultwarden n'expose aucun port public: seul Caddy publie `80` et `443`.
- Inscriptions, invitations et indices de mot de passe desactives par defaut.
- Token admin lu depuis un secret local non versionne.
- Conteneur Vaultwarden en utilisateur non-root, port interne `8080`, capabilities supprimees, filesystem en lecture seule.
- Logs Vaultwarden dans `data/vaultwarden.log`, utilisables avec Fail2Ban.
- Images epinglees: `vaultwarden/server:1.35.7-alpine` et `caddy:2-alpine`.

## Prerequis

- Docker et Docker Compose.
- Un nom de domaine pointant vers le serveur.
- Ports `80/tcp`, `443/tcp` et `443/udp` ouverts vers ce serveur.

## Installation

```bash
cp .env.example .env
./scripts/prepare.sh
```

Edite `.env` et remplace au minimum:

```dotenv
DOMAIN=https://vaultwarden.example.com
ACME_EMAIL=admin@example.com
```

Genere ensuite le token admin Argon2:

```bash
./scripts/generate-admin-token.sh
```

Demarre la pile:

```bash
docker compose up -d
docker compose logs -f
```

L'interface admin sera disponible sur `https://ton-domaine/admin`. Connecte-toi avec le mot de passe que tu as utilise lors de la generation du token.

## Sauvegarde

```bash
./scripts/backup.sh
```

Les archives sont creees dans `backups/`, ignore par Git. Conserve aussi une copie hors du serveur.

## Mise a jour

Lis les notes de version Vaultwarden, puis:

```bash
docker compose pull
docker compose up -d
```

Dependabot est configure pour proposer les mises a jour des images Docker.

## Fail2Ban

Des exemples sont fournis dans `fail2ban/`. Sur un serveur Debian/Ubuntu:

```bash
sudo apt-get install fail2ban -y
sudo cp fail2ban/filter.d/*.local /etc/fail2ban/filter.d/
sudo cp fail2ban/jail.d/*.local /etc/fail2ban/jail.d/
sudo systemctl restart fail2ban
```

Si le projet n'est pas dans `/root/Vaultwarden`, adapte `logpath` dans les fichiers `fail2ban/jail.d/*.local` avant de les copier.

## Secrets

Ne publie jamais:

- `.env`
- `secrets/admin_token`
- `data/`
- `backups/`
- `caddy/data/` et `caddy/config/`

Ils sont deja ignores par `.gitignore`.
