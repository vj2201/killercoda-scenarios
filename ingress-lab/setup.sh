#!/bin/bash
set -e

echo "🚀 Setting up CKA Ingress Practice Lab"

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
echo "[info] Creating echo-sound namespace..."
kubectl get ns echo-sound >/dev/null 2>&1 || kubectl create ns echo-sound

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
  replicas: 2
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

  echo "[info] Waiting for ingress controller to be ready..."
  kubectl wait --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=120s || echo "[warn] Ingress controller may not be fully ready"
else
  echo "[info] Ingress controller already exists"
fi

kubectl rollout status deploy/echo-deployment -n echo-sound --timeout=120s || true
kubectl get deploy,po -n echo-sound || true

echo "✅ Setup complete. Proceed to Step 1."
