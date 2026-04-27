SHELL := /bin/bash

COMPOSE := docker compose
POC_COMPOSE := docker compose -f compose.yaml -f compose.poc.yaml

.DEFAULT_GOAL := help

.PHONY: help env prod-env poc-env prepare token certs renew up down restart logs ps pull update backup config \
	poc-up poc-down poc-restart poc-logs poc-ps poc-config

help:
	@printf "\nCommandes disponibles:\n\n"
	@printf "  make env      Cree .env depuis .env.example si absent\n"
	@printf "  make prod-env Remplace .env par une base de production et sauvegarde l'ancien\n"
	@printf "  make poc-env  Cree .env depuis .env.poc.example si absent\n"
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
	@printf "  make poc-up   Demarre le PoC local sur http://localhost:8080\n"
	@printf "  make poc-down Arrete le PoC local\n"
	@printf "  make poc-logs Suit les logs du PoC local\n"
	@printf "  make poc-ps   Affiche l'etat du PoC local\n"
	@printf "  make poc-config Valide la config du PoC local\n"
	@printf "\nPremier demarrage PoC:\n"
	@printf "  make poc-env\n"
	@printf "  make prepare\n"
	@printf "  editer .env\n"
	@printf "  make token\n"
	@printf "  make poc-up\n\n"
	@printf "Passage en production:\n"
	@printf "  make down\n"
	@printf "  make prod-env\n"
	@printf "  editer .env avec les vraies valeurs du domaine\n"
	@printf "  make certs\n"
	@printf "  make up\n\n"

env:
	@if [ -f .env ]; then \
		printf '.env existe deja, aucune copie effectuee.\n'; \
	else \
		cp .env.example .env; \
		printf '.env cree depuis .env.example. Pense a le personnaliser.\n'; \
	fi

prod-env:
	@./scripts/switch-to-prod-env.sh

poc-env:
	@if [ -f .env ]; then \
		printf '.env existe deja, aucune copie effectuee.\n'; \
	else \
		cp .env.poc.example .env; \
		printf '.env PoC cree depuis .env.poc.example.\n'; \
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

poc-up:
	@$(POC_COMPOSE) up -d

poc-down:
	@$(POC_COMPOSE) down

poc-restart:
	@$(POC_COMPOSE) up -d

poc-logs:
	@$(POC_COMPOSE) logs -f

poc-ps:
	@$(POC_COMPOSE) ps

poc-config:
	@$(POC_COMPOSE) config
