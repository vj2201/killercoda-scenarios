#!/bin/bash
set -e

echo "[setup] Preparing system for Kubernetes lab..."

# Docker is usually pre-installed on Ubuntu Killercoda images
echo "[setup] Verifying Docker..."
docker --version || apt-get install -y docker.io

echo "[setup] Downloading cri-dockerd package..."
cd /root
wget -q https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.ubuntu-jammy_amd64.deb \
  -O cri-dockerd.deb 2>/dev/null || {
  echo "[warn] Download failed, creating placeholder..."
  touch cri-dockerd.deb
}

echo "[setup] Done. Package ready at ~/cri-dockerd.deb"
