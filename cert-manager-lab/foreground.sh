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

# Wait for cert-manager CRDs to be installed
echo "   Waiting for cert-manager installation..."
setup_complete=false
for i in {1..120}; do
  if kubectl get crd certificates.cert-manager.io >/dev/null 2>&1 && \
     kubectl get crd issuers.cert-manager.io >/dev/null 2>&1; then
    setup_complete=true
    echo "   ✓ cert-manager installed"
    break
  fi
  sleep 2
done

if [ "$setup_complete" = "false" ]; then
  echo ""
  echo "⚠️  WARNING: cert-manager installation not detected after 4 minutes."
  echo "   The background setup script may still be running."
  echo ""
  echo "   To check status, run:"
  echo "   kubectl get crd | grep cert-manager"
  echo "   kubectl get pods -n cert-manager"
  echo ""
  echo "   If missing, manually run: bash /root/setup.sh"
  echo ""
else
  echo ""
  echo "✅ Ready! Proceed to Step 1."
  echo ""
fi
