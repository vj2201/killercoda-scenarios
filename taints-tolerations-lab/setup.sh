#!/bin/bash
set -e

echo "[setup] Preparing taints and tolerations lab..."

# Wait for Kubernetes API to be ready
while ! kubectl get nodes &>/dev/null; do
  sleep 2
done

# Wait for control-plane node
echo "[setup] Waiting for control-plane node..."
kubectl wait --for=condition=Ready node/controlplane --timeout=180s 2>/dev/null || true

# Wait for node01 to appear and become ready
echo "[setup] Waiting for node01..."
for i in {1..60}; do
  if kubectl get node node01 &>/dev/null; then
    echo "[setup] node01 found, waiting for Ready status..."
    kubectl wait --for=condition=Ready node/node01 --timeout=180s 2>/dev/null && break
  fi
  sleep 3
done

echo "[setup] Cluster status:"
kubectl get nodes

echo "[setup] Lab environment ready!"
