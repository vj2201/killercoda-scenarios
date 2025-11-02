#!/bin/bash
set -e

echo "🚀 Setting up CKA Ingress Practice Lab"

# Create namespace
echo "[info] Creating echo-sound namespace..."
kubectl create namespace echo-sound --dry-run=client -o yaml | kubectl apply -f -

# Deploy echo application
echo "[info] Creating echo deployment..."
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-deployment
  namespace: echo-sound
  labels:
    app: echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
      - name: echo
        image: hashicorp/http-echo:1.0.0
        args:
          - "-text=Echo response from pod"
        ports:
        - containerPort: 5678
          name: http
YAML

# Install nginx ingress controller (if not already installed)
echo "[info] Checking for ingress controller..."
if ! kubectl get ingressclass nginx >/dev/null 2>&1; then
  echo "[info] Installing nginx ingress controller..."
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
else
  echo "[info] Ingress controller already exists"
fi

echo "✅ Setup complete. Resources are being created..."
