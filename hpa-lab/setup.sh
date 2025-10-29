#!/bin/bash
set -e

echo "🚀 Setting up CKA HorizontalPodAutoscaler Practice Lab"

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
echo "[info] Creating autoscale namespace..."
kubectl get ns autoscale >/dev/null 2>&1 || kubectl create ns autoscale

# Install metrics-server (required for HPA)
echo "[info] Checking for metrics-server..."
if ! kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1; then
  echo "[info] Installing metrics-server..."
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

  # Patch metrics-server for testing environments (allows insecure TLS)
  echo "[info] Patching metrics-server for lab environment..."
  kubectl patch deployment metrics-server -n kube-system --type='json' \
    -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]' || true

  echo "[info] Waiting for metrics-server to be ready..."
  kubectl wait --for=condition=Available --timeout=120s deployment/metrics-server -n kube-system || echo "[warn] metrics-server may not be fully ready"
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

kubectl rollout status deploy/apache-deployment -n autoscale --timeout=120s || true
kubectl get deploy,po -n autoscale || true

echo "[info] Waiting for metrics to be available (this may take 30-60 seconds)..."
sleep 10

echo "✅ Setup complete. Proceed to Step 1."
