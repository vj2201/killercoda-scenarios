#!/bin/bash
set -euo pipefail

echo "=================================================="
echo "=== CKA Resources Lab (Q04): Foreground Setup  ==="
echo "=== Start: $(date)                             ==="
echo "=================================================="

for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[info] Cluster Ready"
    break
  fi
  sleep 2
done

if kubectl get deploy wordpress >/dev/null 2>&1; then
  echo "[info] wordpress already exists"
else
  bash /root/setup.sh || true
fi

kubectl get deploy,po -l app=wordpress || true

echo "=================================================="
echo "=== Proceed to Step 1                          ==="
echo "=================================================="

