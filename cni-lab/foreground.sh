#!/bin/bash
set -euo pipefail

echo "Preparing CNI lab environment..."

echo "  Waiting for Kubernetes cluster..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "  Cluster ready"
    break
  fi
  sleep 2
done

echo "\nReady. Follow Step 1 to install a CNI via manifest using the provided links."

