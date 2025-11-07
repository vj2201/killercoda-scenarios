#!/bin/bash
set -e

echo "🚀 Setting up CKA NodePort Service Practice Lab"

# Create namespace
echo "[info] Creating relative namespace..."
kubectl create namespace relative --dry-run=client -o yaml | kubectl apply -f -

# Create deployment WITHOUT containerPort defined
echo "[info] Creating nodeport-deployment (without containerPort)..."
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nodeport-deployment
  namespace: relative
  labels:
    app: nodeport-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nodeport-app
  template:
    metadata:
      labels:
        app: nodeport-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        # Note: containerPort is NOT defined - user must add it
YAML

echo "✅ Setup complete. Deployment created without containerPort."
echo "   You must: 1) Add containerPort to deployment, 2) Create NodePort Service"
