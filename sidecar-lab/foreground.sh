#!/bin/bash
set -euo pipefail

echo "⏳ Preparing lab environment..."

# Wait for cluster to be ready
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

# Wait for deployment to be created by background setup
for i in {1..60}; do
  if kubectl get deploy wordpress >/dev/null 2>&1; then
    # Wait for it to be ready
    kubectl rollout status deploy/wordpress --timeout=60s >/dev/null 2>&1 || true
    break
  fi
  sleep 2
done

echo "✅ Ready! Proceed to Step 1."
