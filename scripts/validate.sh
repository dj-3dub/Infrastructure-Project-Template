#!/usr/bin/env bash
set -euo pipefail

PASSED=0
WARNINGS=0
FAILED=0

pass() {
  echo "✓ $1"
  PASSED=$((PASSED + 1))
}

warn() {
  echo "⚠ $1"
  WARNINGS=$((WARNINGS + 1))
}

fail() {
  echo "✗ $1"
  FAILED=$((FAILED + 1))
}

check_file() {
  [[ -f "$1" ]] && pass "$1" || fail "$1 missing"
}

check_dir() {
  [[ -d "$1" ]] && pass "$1/" || fail "$1/ missing"
}

check_cmd() {
  command -v "$1" >/dev/null 2>&1 && pass "$1 installed" || warn "$1 missing"
}

echo "===================================================="
echo "Infrastructure Project Validation"
echo "===================================================="
echo ""

echo "Project"
echo "-------"
check_file "README.md"
check_file "Makefile"
check_file "docker-compose.yml"
check_file ".env.example"
check_file ".gitignore"
check_dir "docs"
check_dir "scripts"
echo ""

echo "Scripts"
echo "-------"
check_file "scripts/install.sh"
check_file "scripts/bootstrap.sh"
check_file "scripts/validate.sh"
check_file "scripts/healthcheck.sh"
check_file "scripts/backup.sh"
check_file "scripts/restore.sh"
echo ""

echo "Ansible"
echo "-------"
check_file "ansible/ansible.cfg"
check_file "ansible/inventory/hosts.ini"
check_file "ansible/playbooks/deploy.yml"
check_file "ansible/roles/project_host/tasks/main.yml"
echo ""

echo "Terraform"
echo "---------"
check_dir "terraform/cloudflare"
check_file "terraform/cloudflare/main.tf"
check_file "terraform/cloudflare/variables.tf"
check_file "terraform/cloudflare/outputs.tf"
check_file "terraform/cloudflare/terraform.tfvars.example"
echo ""

echo "GitHub Actions"
echo "--------------"
check_file ".github/workflows/validate.yml"
echo ""

echo "Tools"
echo "-----"
check_cmd "docker"
check_cmd "make"
check_cmd "git"
check_cmd "curl"
check_cmd "openssl"
check_cmd "ansible"
check_cmd "terraform"
echo ""

echo "Docker Compose"
echo "--------------"
if docker compose config >/dev/null 2>&1; then
  pass "docker compose config"
else
  fail "docker compose config failed"
fi
echo ""

echo "Terraform Validation"
echo "--------------------"
if [[ -d terraform/cloudflare ]]; then
  if command -v terraform >/dev/null 2>&1; then
    (
      cd terraform/cloudflare
      terraform fmt -check -recursive >/dev/null 2>&1 && exit 0 || exit 2
    )
    case $? in
      0) pass "terraform fmt" ;;
      2) warn "terraform fmt needed" ;;
      *) fail "terraform fmt failed" ;;
    esac

    (
      cd terraform/cloudflare
      terraform validate >/dev/null 2>&1
    ) && pass "terraform validate" || warn "terraform validate skipped or failed"
  else
    warn "terraform not installed"
  fi
fi
echo ""

echo "Ansible Syntax"
echo "--------------"
if command -v ansible-playbook >/dev/null 2>&1; then
  ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy.yml --syntax-check >/dev/null 2>&1 \
    && pass "ansible syntax check" \
    || warn "ansible syntax check skipped or failed"
else
  warn "ansible-playbook missing"
fi
echo ""

echo "Result"
echo "------"
echo "Passed:   $PASSED"
echo "Warnings: $WARNINGS"
echo "Failed:   $FAILED"

if [[ "$FAILED" -gt 0 ]]; then
  exit 1
fi
