#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="$(basename "$(pwd)")"

echo "=========================================="
echo "$PROJECT_NAME Bootstrap"
echo "=========================================="
echo ""

need_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "$1: OK"
  else
    echo "$1: MISSING"
    return 1
  fi
}

echo "Checking required tools..."
need_cmd git || true
need_cmd make || true
need_cmd curl || true
need_cmd openssl || true
need_cmd docker || true
need_cmd ansible || true
need_cmd terraform || true

echo ""
echo "Checking Docker Compose..."
if docker compose version >/dev/null 2>&1; then
  docker compose version
else
  echo "docker compose: MISSING"
fi

echo ""
echo "Checking project files..."
for file in docker-compose.yml Makefile .env.example scripts/healthcheck.sh; do
  if [[ -f "$file" ]]; then
    echo "$file: OK"
  else
    echo "$file: MISSING"
  fi
done

echo ""
echo "Checking environment file..."
if [[ ! -f .env ]]; then
  if [[ -f .env.example ]]; then
    cp .env.example .env
    echo ".env created from .env.example"
  else
    echo ".env.example missing; cannot create .env"
  fi
else
  echo ".env: OK"
fi

echo ""
echo "Setting script permissions..."
chmod +x scripts/*.sh
echo "scripts/*.sh: executable"

echo ""
echo "Bootstrap complete."
echo "Next steps:"
echo "  1. Edit .env"
echo "  2. Run: make validate"
echo "  3. Run: make up"
