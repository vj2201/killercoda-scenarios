#!/bin/bash
set -e

echo "🚀 Setting up CKA NodePort Service Practice Lab"

echo "[info] Waiting for Kubernetes API & Ready node..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[info] Cluster Ready"
    break
  fi
  sleep 2
  if [ "$i" -eq 90 ]; then echo "[warn] Proceeding without Ready confirmation"; fi
done

# Create namespace
echo "[info] Creating relative namespace..."
kubectl get ns relative >/dev/null 2>&1 || kubectl create ns relative

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
  replicas: 2
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

kubectl rollout status deploy/nodeport-deployment -n relative --timeout=120s || true
kubectl get deploy,po -n relative || true

echo "✅ Setup complete. Deployment created without containerPort."
echo "   You must: 1) Add containerPort to deployment, 2) Create NodePort Service"
