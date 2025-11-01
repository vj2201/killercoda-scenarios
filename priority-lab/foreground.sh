#!/bin/bash
set -euo pipefail

echo "Preparing lab environment..."

# Wait for cluster to be ready
echo "   Waiting for Kubernetes cluster..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "   Cluster ready"
    break
  fi
  sleep 2
  if [ "$i" -eq 90 ]; then
    echo "   Cluster not ready after 3 minutes, continuing anyway..."
  fi
done

# Wait for namespace and deployment to be created by background setup
echo "   Waiting for setup to complete..."
setup_complete=false
pc_ready=false
for i in {1..120}; do
  ns_ok=false
  dep_ok=false
  if kubectl get ns priority >/dev/null 2>&1; then ns_ok=true; fi
  if kubectl -n priority get deploy busybox-logger >/dev/null 2>&1; then dep_ok=true; fi
  if kubectl get priorityclass medium-priority >/dev/null 2>&1; then pc_ready=true; fi
  if [ "$ns_ok" = "true" ] && [ "$dep_ok" = "true" ]; then
    setup_complete=true
    echo "   Setup complete"
    break
  fi
  sleep 2
done

if [ "$setup_complete" = "false" ]; then
  echo ""
  echo "WARNING: Setup did not complete within 4 minutes."
  echo "   The background setup script may still be running."
  echo ""
  echo "   To check status, run:"
  echo "   kubectl get ns priority"
  echo "   kubectl get priorityclass"
  echo "   kubectl get deploy -n priority"
  echo ""
  echo "   If resources are missing, manually run:"
  echo "   bash /root/setup.sh  # or, depending on the environment"
  echo "   bash /root/background.sh"
  echo ""
else
  echo ""
  echo "Ready! Proceed to Step 1."
  echo ""
  if [ "$pc_ready" = "false" ]; then
    echo "   Note: PriorityClass 'medium-priority' is still initializing; continuing."
    echo "   You can check later with: kubectl get priorityclass"
    echo ""
  fi
fi
