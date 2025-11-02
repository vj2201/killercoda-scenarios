#!/bin/bash
set -e

echo "🚀 Setting up CKA cert-manager CRD Practice Lab"

# Check if cert-manager is already installed
if kubectl get crd certificates.cert-manager.io >/dev/null 2>&1; then
  echo "[info] cert-manager CRDs already exist"
else
  echo "[info] Installing cert-manager..."
  kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml
  echo "[info] cert-manager is being installed..."
fi

echo "[info] Verifying cert-manager CRDs..."
kubectl get crd | grep cert-manager || true

echo "✅ Setup complete. cert-manager installed with CRDs."
