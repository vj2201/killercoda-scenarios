#!/bin/bash
set -euo pipefail

echo "[setup] Preparing system for Kubernetes lab..."

echo "[setup] Installing Docker..."
# Install Docker if not already installed
if ! command -v docker &> /dev/null; then
  apt-get update -qq
  apt-get install -y docker.io
  systemctl enable docker
  systemctl start docker
else
  echo "[info] Docker already installed"
fi

echo "[setup] Downloading cri-dockerd package..."
cd /root
wget -q https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.20/cri-dockerd_0.3.20.3-0.ubuntu-jammy_amd64.deb \
  -O cri-dockerd.deb 2>/dev/null || {
  echo "[warn] Could not download package from GitHub, creating placeholder..."
  touch cri-dockerd.deb
}

ls -lh /root/cri-dockerd.deb

echo "[setup] Setup complete!"
echo ""
echo "Docker version:"
docker --version
echo ""
echo "Package available at:"
ls -lh ~/cri-dockerd.deb
