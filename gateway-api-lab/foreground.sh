#!/bin/bash
set -euo pipefail

echo "⏳ Preparing lab environment..."

ns=web-migration

# Wait for cluster to be ready
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

# Wait for namespace and deployments to be created by background setup
for i in {1..60}; do
  if kubectl get ns "$ns" >/dev/null 2>&1 && \
     kubectl -n "$ns" get deploy web-deploy >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

echo "✅ Ready! Proceed to Step 1."
