#!/bin/bash
set -e

echo "[setup] Preparing taints and tolerations lab..."

# Wait for Kubernetes to be ready
while ! kubectl get nodes &>/dev/null; do
  sleep 2
done

# Wait for node01 to be ready
echo "[setup] Waiting for node01..."
kubectl wait --for=condition=Ready node/node01 --timeout=300s 2>/dev/null || true

echo "[setup] Lab environment ready!"
