# Infrastructure Project Template

A standardized, production-ready template for building infrastructure and homelab projects with Docker, Make, Ansible, Terraform, and GitHub Actions.

This template provides a repeatable project structure, operational tooling, and automation so every infrastructure project starts from the same foundation.

---

## Why This Template Exists

Infrastructure projects often evolve organically, resulting in inconsistent repository layouts, duplicated scripts, and different operational workflows.

This template establishes a consistent engineering standard by providing:

* A repeatable repository structure
* Automated installation and bootstrapping
* Project validation
* Infrastructure-as-Code scaffolding
* Deployment automation
* Health checks
* Backup and restore framework
* GitHub Actions continuous validation

The goal is simple:

> Every infrastructure project should behave the same way regardless of the application it deploys.

---

# Features

* Docker Compose project layout
* Universal Makefile
* Installation and bootstrap automation
* Project validation framework
* Health check framework
* Backup and restore framework
* Ansible deployment scaffold
* Terraform scaffold
* GitHub Actions validation
* Documentation templates
* Versioned project releases

---

# Repository Structure

```text
.
├── ansible/
├── backups/
├── docs/
├── monitoring/
├── scripts/
├── terraform/
├── .github/
├── docker-compose.yml
├── Makefile
├── README.md
└── VERSION
```

---

# Quick Start

Clone the repository.

```bash
git clone https://github.com/<your-account>/<project>.git
cd <project>
```

Install project prerequisites.

```bash
make install
```

Bootstrap the project.

```bash
make bootstrap
```

Validate the project.

```bash
make validate
```

Deploy the project.

```bash
make up
```

Verify project health.

```bash
make health
```

---

# Project Lifecycle

Every project created from this template follows the same operational workflow.

```text
Install
   │
   ▼
Bootstrap
   │
   ▼
Validate
   │
   ▼
Deploy
   │
   ▼
Health Check
   │
   ▼
Operate
   │
   ▼
Backup
```

---

# Standard Make Targets

## Setup

```bash
make install
make bootstrap
make validate
```

## Docker

```bash
make up
make down
make restart
make status
make logs
make update
make clean
```

## Operations

```bash
make health
make report
make diag
```

## Backup

```bash
make backup
make restore
```

## Ansible

```bash
make ansible-ping
make ansible-check
make ansible-deploy
```

## Terraform

```bash
make tf-init
make tf-fmt
make tf-validate
make tf-plan
make tf-apply
make tf-destroy
```

---

# Validation

Run a complete validation before committing changes.

```bash
make validate
```

Validation includes:

* Repository structure
* Docker Compose configuration
* Terraform validation
* Ansible syntax validation
* Script verification
* GitHub workflow validation
* Required tooling verification

---

# Health Checks

Run:

```bash
make health
```

The template provides a reusable health framework.

Individual projects extend these checks to monitor their own services and endpoints.

---

# Continuous Integration

The included GitHub Actions workflow validates every push and pull request by checking:

* Docker Compose configuration
* Terraform formatting
* Terraform validation
* Ansible syntax
* Project validation

---

# Versioning

This repository uses a root-level `VERSION` file to identify template releases.

Projects created from this template can reference the template version they were built from.

Example:

```text
Infrastructure Project Template v1.0.0
```

---

# Using This Template

1. Click **Use this template** on GitHub.
2. Create a new repository.
3. Clone the new repository.
4. Customize the project for your application.
5. Keep the operational workflow consistent.

---

# Roadmap

Future improvements may include:

* Graphviz architecture template
* ShellCheck integration
* YAML linting
* Markdown linting
* Secret generation framework
* Multi-host Ansible support
* Additional Terraform provider templates

---

# License

MIT License
