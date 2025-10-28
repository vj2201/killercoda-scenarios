#!/bin/bash
set -euo pipefail

echo "=================================================="
echo "=== Gateway API Migration Lab: Auto Setup     ==="
echo "=== Start: $(date)                           ==="
echo "=================================================="

ns=web-migration
echo "[info] Ensuring namespace $ns exists"
kubectl get ns "$ns" >/dev/null 2>&1 || kubectl create ns "$ns"

if ! kubectl -n "$ns" get deploy web-deploy >/dev/null 2>&1; then
  echo "[info] Applying baseline app and Ingress"
  bash /root/setup.sh || true
fi

kubectl -n "$ns" get deploy,svc,ingress || true

echo "=================================================="
echo "=== Next: Create Gateway (step 2)             ==="
echo "=== Then: Create HTTPRoute (step 3)           ==="
echo "=================================================="

