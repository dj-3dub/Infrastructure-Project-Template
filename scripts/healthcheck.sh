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

check_cmd() {
  command -v "$1" >/dev/null 2>&1 && pass "$1 installed" || warn "$1 missing"
}

check_port() {
  local port="$1"
  local name="$2"

  if ss -tuln | grep -q ":${port} "; then
    pass "$name port $port listening"
  else
    warn "$name port $port not listening"
  fi
}

check_http() {
  local url="$1"
  local name="$2"

  if curl -fsS "$url" >/dev/null 2>&1; then
    pass "$name reachable"
  else
    warn "$name not reachable"
  fi
}

echo "===================================================="
echo "Infrastructure Project Health Check"
echo "===================================================="
echo ""

echo "Tools"
echo "-----"
check_cmd docker
check_cmd curl
check_cmd ss
echo ""

echo "Docker"
echo "------"
if docker info >/dev/null 2>&1; then
  pass "Docker engine running"
else
  fail "Docker engine not running"
fi

if docker compose ps >/dev/null 2>&1; then
  pass "Docker Compose project available"
else
  warn "Docker Compose project unavailable"
fi
echo ""

echo "Containers"
echo "----------"
if docker compose ps --format json >/dev/null 2>&1; then
  docker compose ps
else
  warn "No Compose containers found or Compose config invalid"
fi
echo ""

echo "Common Ports"
echo "------------"
check_port 80 "HTTP"
check_port 443 "HTTPS"
check_port 3000 "Grafana"
check_port 9090 "Prometheus"
check_port 9000 "Application"
echo ""

echo "HTTP Checks"
echo "-----------"
check_http "http://localhost:3000/api/health" "Grafana"
check_http "http://localhost:9090/-/healthy" "Prometheus"
echo ""

echo "Result"
echo "------"
echo "Passed:   $PASSED"
echo "Warnings: $WARNINGS"
echo "Failed:   $FAILED"

if [[ "$FAILED" -gt 0 ]]; then
  exit 1
fi
