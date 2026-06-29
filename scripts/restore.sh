#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-backups}"

echo "Available backups:"
ls -1 "$BACKUP_DIR" 2>/dev/null || {
  echo "No backups found."
  exit 1
}

echo ""
echo "Restore is project-specific."
echo "Use this script as a safe placeholder and customize it per project."
echo ""
echo "Example:"
echo "  BACKUP=backups/20260101-120000 ./scripts/restore.sh"
