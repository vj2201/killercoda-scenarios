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
crds_ready=false
resources_ready=false

for i in {1..90}; do
  # Check CRDs
  if kubectl get crd gateways.gateway.networking.k8s.io >/dev/null 2>&1 && \
     kubectl get crd httproutes.gateway.networking.k8s.io >/dev/null 2>&1; then
    if [ "$crds_ready" = "false" ]; then
      echo "   ✓ Gateway API CRDs installed"
      crds_ready=true
    fi
  fi

  # Check resources
  if kubectl get ns web-app >/dev/null 2>&1 && \
     kubectl -n web-app get ingress web >/dev/null 2>&1 && \
     kubectl get gatewayclass nginx-class >/dev/null 2>&1; then
    resources_ready=true
    echo "   ✓ Setup complete"
    break
  fi
  sleep 2
done

setup_complete="$resources_ready"

if [ "$setup_complete" = "false" ]; then
  echo ""
  echo "⚠️  WARNING: Setup did not complete within 3 minutes."
  echo ""
  if [ "$crds_ready" = "false" ]; then
    echo "   ⚠ Gateway API CRDs not installed!"
    echo "   Install manually: kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml"
    echo ""
  fi
  echo "   To check status:"
  echo "   kubectl get crd | grep gateway"
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
