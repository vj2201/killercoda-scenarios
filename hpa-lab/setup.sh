#!/bin/bash
set -e

echo "🚀 Setting up CKA HorizontalPodAutoscaler Practice Lab"

# Create namespace
echo "[info] Creating autoscale namespace..."
kubectl create namespace autoscale --dry-run=client -o yaml | kubectl apply -f -

# Install metrics-server (required for HPA)
echo "[info] Checking for metrics-server..."
if ! kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1; then
  echo "[info] Installing metrics-server..."
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

  # Patch metrics-server for testing environments (allows insecure TLS)
  echo "[info] Patching metrics-server for lab environment..."
  kubectl patch deployment metrics-server -n kube-system --type='json' \
    -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]' || true

  echo "[info] metrics-server is starting..."
else
  echo "[info] metrics-server already exists"
fi

# Create apache deployment with resource requests (required for CPU-based HPA)
echo "[info] Creating apache-deployment..."
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  namespace: autoscale
  labels:
    app: apache
spec:
  replicas: 1
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: httpd:2.4
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
YAML

echo "✅ Setup complete. Metrics will be available shortly."
