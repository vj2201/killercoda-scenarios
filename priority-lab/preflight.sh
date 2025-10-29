#!/bin/sh
set -e

echo "=== preflight start (priority-lab): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get ns priority >/dev/null 2>&1; then
  echo "[info] priority namespace present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

kubectl get deploy,po -n priority || true
echo "=== preflight end (priority-lab): $(date) ==="
