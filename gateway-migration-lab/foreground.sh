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

echo "   Installing Gateway API CRDs (may take 1-2 minutes)..."
setup_complete=false
for i in {1..90}; do
  if kubectl get crd gateways.gateway.networking.k8s.io >/dev/null 2>&1 && \
     kubectl get ns web-app >/dev/null 2>&1 && \
     kubectl -n web-app get ingress web >/dev/null 2>&1 && \
     kubectl get gatewayclass nginx-class >/dev/null 2>&1; then
    setup_complete=true
    echo "   ✓ Setup complete"
    break
  fi
  sleep 2
done

if [ "$setup_complete" = "false" ]; then
  echo ""
  echo "⚠️  WARNING: Setup did not complete within 3 minutes."
  echo "   To check status:"
  echo "   kubectl get gatewayclass"
  echo "   kubectl get ingress -n web-app"
  echo ""
  echo "   If missing, run: bash /root/setup.sh"
  echo ""
else
  echo ""
  echo "✅ Ready! Proceed to the task."
  echo ""
fi
