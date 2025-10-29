#!/bin/sh
set -e

echo "=== preflight start (pv-recovery-lab): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get ns mariadb >/dev/null 2>&1; then
  echo "[info] mariadb namespace present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

kubectl get pv || true
echo "=== preflight end (pv-recovery-lab): $(date) ==="
