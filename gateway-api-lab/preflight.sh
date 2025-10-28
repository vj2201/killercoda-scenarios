#!/bin/sh
set -e

echo "=== preflight start: $(date) ==="
echo "[info] context: $(kubectl config current-context 2>/dev/null || echo unknown)"

ns=web-migration
if ! kubectl get ns "$ns" >/dev/null 2>&1; then
  echo "[info] creating namespace $ns"
  kubectl create ns "$ns" || true
fi

if ! kubectl -n "$ns" get deploy web-deploy >/dev/null 2>&1; then
  if [ -x /root/setup.sh ]; then
    echo "[info] running /root/setup.sh"
    bash /root/setup.sh || true
  fi
fi

kubectl -n "$ns" get deploy,svc,ingress || true
echo "=== preflight end: $(date) ==="

