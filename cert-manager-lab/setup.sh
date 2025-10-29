#!/bin/bash
set -e

echo "🚀 Setting up CKA cert-manager CRD Practice Lab"

echo "[info] Waiting for Kubernetes API & Ready node..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[info] Cluster Ready"
    break
  fi
  sleep 2
  if [ "$i" -eq 90 ]; then echo "[warn] Proceeding without Ready confirmation"; fi
done

# Check if cert-manager is already installed
if kubectl get crd certificates.cert-manager.io >/dev/null 2>&1; then
  echo "[info] cert-manager CRDs already exist"
else
  echo "[info] Installing cert-manager..."
  kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml

  echo "[info] Waiting for cert-manager to be ready..."
  kubectl wait --for=condition=Available --timeout=120s \
    deployment/cert-manager -n cert-manager 2>/dev/null || true
  kubectl wait --for=condition=Available --timeout=120s \
    deployment/cert-manager-webhook -n cert-manager 2>/dev/null || true
  kubectl wait --for=condition=Available --timeout=120s \
    deployment/cert-manager-cainjector -n cert-manager 2>/dev/null || true
fi

echo "[info] Verifying cert-manager CRDs..."
kubectl get crd | grep cert-manager || true

echo "✅ Setup complete. cert-manager installed with CRDs."
