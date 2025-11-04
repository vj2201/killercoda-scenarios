#!/bin/sh
set -e

echo "=== preflight start (k8s-system-prep-lab): $(date) ==="

for i in $(seq 1 60); do
  if command -v docker >/dev/null 2>&1; then
    echo "[info] Docker present"
    break
  fi
  sleep 2
done

if [ ! -f /root/cri-dockerd_0.3.9.3-0.ubuntu-jammy_amd64.deb ]; then
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

docker --version || true
echo "=== preflight end (k8s-system-prep-lab): $(date) ==="
