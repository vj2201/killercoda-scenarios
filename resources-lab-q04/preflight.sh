#!/bin/sh
set -e

echo "=== preflight start (Q04): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get deploy wordpress >/dev/null 2>&1; then
  echo "[info] wordpress present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

kubectl get deploy,po -l app=wordpress || true
echo "=== preflight end (Q04): $(date) ==="

