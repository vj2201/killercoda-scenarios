#!/bin/sh
set -e

echo "=== preflight start (cert-manager-lab): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get crd certificates.cert-manager.io >/dev/null 2>&1; then
  echo "[info] cert-manager CRDs present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

kubectl get crd | grep cert-manager || true
echo "=== preflight end (cert-manager-lab): $(date) ==="
