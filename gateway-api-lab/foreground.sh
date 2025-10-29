#!/bin/bash
set -euo pipefail

echo "⏳ Preparing lab environment..."

ns=web-migration

# Wait for cluster to be ready
echo "   Waiting for Kubernetes cluster..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "   ✓ Cluster ready"
    break
  fi
  sleep 2
  if [ "$i" -eq 90 ]; then
    echo "   ⚠ Cluster not ready after 3 minutes, continuing anyway..."
  fi
done

# Wait for namespace and deployments to be created by background setup
echo "   Waiting for setup to complete..."
setup_complete=false
for i in {1..60}; do
  if kubectl get ns "$ns" >/dev/null 2>&1 && \
     kubectl -n "$ns" get deploy web-deploy >/dev/null 2>&1; then
    setup_complete=true
    echo "   ✓ Setup complete"
    break
  fi
  sleep 2
done

if [ "$setup_complete" = "false" ]; then
  echo ""
  echo "⚠️  WARNING: Setup did not complete within 2 minutes."
  echo "   The background setup script may still be running."
  echo ""
  echo "   To check status, run:"
  echo "   kubectl get ns web-migration"
  echo "   kubectl get deploy -n web-migration"
  echo ""
  echo "   If missing, manually run: bash /root/setup.sh"
  echo ""
else
  echo ""
  echo "✅ Ready! Proceed to Step 1."
  echo ""
fi
