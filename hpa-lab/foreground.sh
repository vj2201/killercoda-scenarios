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

# Wait for namespace
echo "   Waiting for namespace..."
for i in {1..30}; do
  if kubectl get ns autoscale >/dev/null 2>&1; then
    echo "   ✓ Namespace created"
    break
  fi
  sleep 2
done

# Wait for metrics-server (this is the slow part)
echo "   Installing metrics-server (may take 1-2 minutes)..."
metrics_ready=false
for i in {1..60}; do
  if kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1; then
    echo "   ✓ Metrics-server deployed"
    metrics_ready=true
    break
  fi
  sleep 2
done

# Wait for apache deployment
if [ "$metrics_ready" = "true" ]; then
  echo "   Waiting for apache deployment..."
  for i in {1..30}; do
    if kubectl -n autoscale get deploy apache-deployment >/dev/null 2>&1; then
      echo "   ✓ Apache deployment created"
      break
    fi
    sleep 2
  done
fi

# Final verification
setup_complete=false
if kubectl get ns autoscale >/dev/null 2>&1 && \
   kubectl -n autoscale get deploy apache-deployment >/dev/null 2>&1 && \
   kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1; then
  setup_complete=true
fi

if [ "$setup_complete" = "false" ]; then
  echo ""
  echo "⚠️  WARNING: Setup did not complete within 4 minutes."
  echo "   The background setup script may still be running."
  echo ""
  echo "   To check status, run:"
  echo "   kubectl get ns autoscale"
  echo "   kubectl get deploy -n autoscale"
  echo "   kubectl get deploy metrics-server -n kube-system"
  echo ""
  echo "   If resources are missing, manually run: bash /root/setup.sh"
  echo ""
else
  echo ""
  echo "✅ Ready! Proceed to Step 1."
  echo ""
  echo "   Note: Metrics may take 30-60 seconds to become available."
  echo ""
fi
