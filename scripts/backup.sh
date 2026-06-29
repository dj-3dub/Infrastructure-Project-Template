#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-backups}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="${BACKUP_DIR}/${STAMP}"

mkdir -p "$OUT_DIR"

echo "Creating backup directory: $OUT_DIR"

if [[ -f .env ]]; then
  cp .env "$OUT_DIR/.env.backup"
  echo "✓ Backed up .env"
else
  echo "⚠ .env not found"
fi

if [[ -f docker-compose.yml ]]; then
  cp docker-compose.yml "$OUT_DIR/docker-compose.yml.backup"
  echo "✓ Backed up docker-compose.yml"
fi

docker compose ps > "$OUT_DIR/compose-status.txt" 2>/dev/null || true

echo ""
echo "Backup complete: $OUT_DIR"
