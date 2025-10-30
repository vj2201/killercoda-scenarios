#!/bin/bash
set -euo pipefail

echo "Preparing MariaDB PVC recovery lab..."

echo "  Waiting for Kubernetes cluster..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "  Cluster ready"
    break
  fi
  sleep 2
done

echo "  Verifying retained PV exists..."
kubectl get pv || true

echo "\nReady. Follow the step to create PVC 'mariadb', edit /root/mariadb-deploy.yaml to use it, and apply."

