#!/bin/bash
set -euo pipefail

echo "⏳ Preparing lab environment..."

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

# Wait for deployment to be created by background setup
echo "   Waiting for setup to complete..."
setup_complete=false
for i in {1..60}; do
  if kubectl get deploy wordpress >/dev/null 2>&1; then
    # Wait for it to be ready
    kubectl rollout status deploy/wordpress --timeout=60s >/dev/null 2>&1 || true
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
  echo "   To check status, run: kubectl get deploy wordpress"
  echo "   If missing, manually run: bash /root/setup.sh"
  echo ""
else
  echo ""
  echo "✅ Ready! Proceed to Step 1."
  echo ""
fi
