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

# Wait for namespace, deployment, and PriorityClasses to be created by background setup
echo "   Waiting for setup to complete..."
setup_complete=false
for i in {1..120}; do
  ns_ok=false
  dep_ok=false
  pc_ok=false
  if kubectl get ns priority >/dev/null 2>&1; then ns_ok=true; fi
  if kubectl -n priority get deploy busybox-logger >/dev/null 2>&1; then dep_ok=true; fi
  if kubectl get priorityclass user-medium-priority >/dev/null 2>&1 && kubectl get priorityclass user-normal-priority >/dev/null 2>&1; then pc_ok=true; fi
  if [ "$ns_ok" = "true" ] && [ "$dep_ok" = "true" ] && [ "$pc_ok" = "true" ]; then
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
  echo "   Attempting to ensure PriorityClasses exist..."
  if ! kubectl get priorityclass user-medium-priority >/dev/null 2>&1 || ! kubectl get priorityclass user-normal-priority >/dev/null 2>&1; then
    kubectl apply -f - <<'YAML' || true
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: user-medium-priority
value: 1000
globalDefault: false
description: "User-defined: Medium priority for important workloads"
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: user-normal-priority
value: 500
globalDefault: false
description: "User-defined: Normal priority for regular workloads"
YAML
  fi
  echo "   If resources are missing, manually run:"
  echo "   bash /root/setup.sh"
  echo ""
else
  echo ""
  echo "Ready! Proceed to Step 1."
  echo ""
  echo "Verify resources are ready:"
  echo "   kubectl get priorityclass user-medium-priority user-normal-priority"
  echo "   kubectl get deploy -n priority"
  echo ""
fi
