#!/bin/sh
set -e

echo "=== preflight start (nodeport-lab): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get ns relative >/dev/null 2>&1; then
  echo "[info] relative namespace present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

kubectl get deploy -n relative || true
echo "=== preflight end (nodeport-lab): $(date) ==="
