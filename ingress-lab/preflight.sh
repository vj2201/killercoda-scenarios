#!/bin/sh
set -e

echo "=== preflight start (ingress-lab): $(date) ==="
kubectl version || true

for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

if kubectl get ns echo-sound >/dev/null 2>&1; then
  echo "[info] echo-sound namespace present"
else
  if [ -x /root/setup.sh ]; then
    bash /root/setup.sh || true
  fi
fi

kubectl get deploy,po -n echo-sound || true
echo "=== preflight end (ingress-lab): $(date) ==="
