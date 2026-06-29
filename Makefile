# ==========================================================
# Infrastructure Project Template
# ==========================================================

SHELL := /bin/bash

COMPOSE := docker compose
ANSIBLE := ansible-playbook
TERRAFORM := terraform

TF_DIR := terraform/cloudflare
ANSIBLE_INVENTORY := ansible/inventory/hosts.ini
ANSIBLE_PLAYBOOK := ansible/playbooks/deploy.yml

.PHONY: help \
	bootstrap up down restart logs status ps config pull update clean \
	health validate diag report \
	backup restore \
	ansible-ping ansible-check ansible-deploy \
	tf-init tf-fmt tf-validate tf-plan tf-apply tf-destroy \
        install
help:
	@echo "Infrastructure Project Template"
	@echo ""
	@echo "Setup"
	@echo "  make bootstrap"
	@echo "  make validate"
	@echo ""
	@echo "Docker"
	@echo "  make up down restart status logs config pull update clean"
	@echo ""
	@echo "Health"
	@echo "  make health"
	@echo "  make diag"
	@echo "  make report"
	@echo ""
	@echo "Ansible"
	@echo "  make ansible-ping"
	@echo "  make ansible-check"
	@echo "  make ansible-deploy"
	@echo ""
	@echo "Terraform"
	@echo "  make tf-init"
	@echo "  make tf-fmt"
	@echo "  make tf-validate"
	@echo "  make tf-plan"
	@echo "  make tf-apply"
	@echo "  make tf-destroy"
	@echo ""
	@echo "Backup"
	@echo "  make backup"
	@echo "  make restore"
	@echo "  make install"
	@echo "  make bootstrap"
	@echo "  make validate"
# ==========================================================
# Setup
# ==========================================================

bootstrap:
	./scripts/bootstrap.sh

install:
	./scripts/install.sh

# ==========================================================
# Docker
# ==========================================================

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart

logs:
	$(COMPOSE) logs -f

status:
	$(COMPOSE) ps

ps:
	$(COMPOSE) ps

config:
	$(COMPOSE) config

pull:
	$(COMPOSE) pull

update: pull
	$(COMPOSE) up -d

clean:
	$(COMPOSE) down --remove-orphans

# ==========================================================
# Health / Validation
# ==========================================================

health:
	./scripts/healthcheck.sh

validate:
	./scripts/validate.sh

diag:
	@echo "===== System Tools ====="
	@command -v docker >/dev/null && docker --version || echo "docker: missing"
	@command -v docker >/dev/null && $(COMPOSE) version || echo "docker compose: missing"
	@command -v make >/dev/null && make --version | head -1 || echo "make: missing"
	@command -v git >/dev/null && git --version || echo "git: missing"
	@command -v curl >/dev/null && curl --version | head -1 || echo "curl: missing"
	@command -v openssl >/dev/null && openssl version || echo "openssl: missing"
	@command -v ansible >/dev/null && ansible --version | head -1 || echo "ansible: missing"
	@command -v terraform >/dev/null && terraform version | head -1 || echo "terraform: missing"

report: status health
	@echo ""
	@echo "Project report complete."

# ==========================================================
# Backup / Restore
# ==========================================================

backup:
	./scripts/backup.sh

restore:
	./scripts/restore.sh

# ==========================================================
# Ansible
# ==========================================================

ansible-ping:
	ansible all -i $(ANSIBLE_INVENTORY) -m ping

ansible-check:
	$(ANSIBLE) -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK) --check

ansible-deploy:
	$(ANSIBLE) -i $(ANSIBLE_INVENTORY) $(ANSIBLE_PLAYBOOK)

# ==========================================================
# Terraform
# ==========================================================

tf-init:
	cd $(TF_DIR) && $(TERRAFORM) init

tf-fmt:
	cd $(TF_DIR) && $(TERRAFORM) fmt -recursive

tf-validate:
	cd $(TF_DIR) && $(TERRAFORM) validate

tf-plan:
	cd $(TF_DIR) && $(TERRAFORM) plan

tf-apply:
	cd $(TF_DIR) && $(TERRAFORM) apply

tf-destroy:
	cd $(TF_DIR) && $(TERRAFORM) destroy
