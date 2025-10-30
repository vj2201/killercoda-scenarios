#!/bin/sh
set -e

echo "=== preflight start (network-policy-lab): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get ns frontend >/dev/null 2>&1 && kubectl get ns backend >/dev/null 2>&1; then
  echo "[info] namespaces present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

kubectl get deploy -n frontend || true
kubectl get deploy -n backend || true
echo "=== preflight end (network-policy-lab): $(date) ==="
