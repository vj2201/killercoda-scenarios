#!/bin/bash
set -euo pipefail

echo "Preparing NetworkPolicy lab environment..."

echo "  Waiting for Kubernetes cluster..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "  Cluster ready"
    break
  fi
  sleep 2
done

echo "  Waiting for namespaces and deployments..."
for i in {1..90}; do
  if kubectl get ns frontend >/dev/null 2>&1 && \
     kubectl get ns backend  >/dev/null 2>&1 && \
     kubectl -n frontend get deploy frontend >/dev/null 2>&1 && \
     kubectl -n backend  get deploy backend  >/dev/null 2>&1; then
    echo "  Setup complete"
    break
  fi
  sleep 2
done

if [ -d /root/network-policies ]; then
  echo "\nCandidate policies in /root/network-policies:"
  ls -1 /root/network-policies || true
fi

echo "\nReady. Proceed to the step instructions."

