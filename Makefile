SHELL := /bin/bash

COMPOSE := docker compose

.DEFAULT_GOAL := help

.PHONY: help env prepare token certs renew up down restart logs ps pull update backup config

help:
	@printf "\nCommandes disponibles:\n\n"
	@printf "  make env      Cree .env depuis .env.example si absent\n"
	@printf "  make prepare  Prepare les dossiers et permissions\n"
	@printf "  make token    Genere et enregistre le token admin Argon2\n"
	@printf "  make certs    Initialise le certificat Let's Encrypt\n"
	@printf "  make renew    Renouvelle les certificats TLS\n"
	@printf "  make up       Demarre la stack en arriere-plan\n"
	@printf "  make down     Arrete la stack\n"
	@printf "  make restart  Redemarre la stack\n"
	@printf "  make logs     Suit les logs des services\n"
	@printf "  make ps       Affiche l'etat des conteneurs\n"
	@printf "  make pull     Recupere les nouvelles images\n"
	@printf "  make update   Met a jour les images puis relance la stack\n"
	@printf "  make backup   Sauvegarde le dossier data/\n"
	@printf "  make config   Valide et affiche la config Docker Compose\n"
	@printf "\nDemarrage recommande:\n"
	@printf "  make env && make prepare\n"
	@printf "  editer .env\n"
	@printf "  make token\n"
	@printf "  make certs\n"
	@printf "  make up\n\n"

env:
	@if [ -f .env ]; then \
		printf '.env existe deja, aucune copie effectuee.\n'; \
	else \
		cp .env.example .env; \
		printf '.env cree depuis .env.example. Pense a le personnaliser.\n'; \
	fi

prepare:
	@./scripts/prepare.sh

token:
	@./scripts/generate-admin-token.sh

certs:
	@./scripts/init-letsencrypt.sh

renew:
	@./scripts/renew-certs.sh

up:
	@$(COMPOSE) up -d

down:
	@$(COMPOSE) down

restart:
	@$(COMPOSE) up -d

logs:
	@$(COMPOSE) logs -f

ps:
	@$(COMPOSE) ps

pull:
	@$(COMPOSE) pull

update: pull up

backup:
	@./scripts/backup.sh

config:
	@$(COMPOSE) config
