#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "Infrastructure Project Installer"
echo "=========================================="
echo ""

if [[ $EUID -eq 0 ]]; then
  echo "Do not run this script as root. Use your normal user with sudo access."
  exit 1
fi

echo "Updating apt..."
sudo apt update

echo ""
echo "Installing baseline packages..."
sudo apt install -y \
  git \
  curl \
  wget \
  unzip \
  ca-certificates \
  gnupg \
  lsb-release \
  software-properties-common \
  make \
  jq \
  tree \
  openssl \
  ansible

echo ""
echo "Checking Docker..."
if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is missing. Install Docker Engine before continuing:"
  echo "https://docs.docker.com/engine/install/ubuntu/"
else
  echo "Docker: OK"
fi

echo ""
echo "Installing Terraform repository..."
if ! command -v terraform >/dev/null 2>&1; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

  sudo apt update
  sudo apt install -y terraform
else
  echo "Terraform: OK"
fi

echo ""
echo "Install complete."
echo "Next:"
echo "  make bootstrap"
echo "  make validate"
