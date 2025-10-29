#!/bin/bash
set -euo pipefail

echo "⏳ Preparing lab environment..."

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

echo "   Waiting for setup to complete..."
setup_complete=false
for i in {1..60}; do
  if kubectl get ns relative >/dev/null 2>&1 && \
     kubectl -n relative get deploy nodeport-deployment >/dev/null 2>&1; then
    setup_complete=true
    echo "   ✓ Setup complete"
    break
  fi
  sleep 2
done

if [ "$setup_complete" = "false" ]; then
  echo ""
  echo "⚠️  WARNING: Setup did not complete within 2 minutes."
  echo "   To check status: kubectl get deploy -n relative"
  echo "   If missing, run: bash /root/setup.sh"
  echo ""
else
  echo ""
  echo "✅ Ready! Proceed to Step 1."
  echo ""
fi
