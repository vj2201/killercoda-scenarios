#!/bin/bash
set -euo pipefail

echo "[setup] Creating namespaces..."
kubectl create namespace frontend 2>/dev/null || true
kubectl create namespace backend 2>/dev/null || true

echo "[setup] Creating Backend deployment..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: backend
  labels:
    app: backend
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
      tier: api
  template:
    metadata:
      labels:
        app: backend
        tier: api
    spec:
      containers:
      - name: backend
        image: hashicorp/http-echo:latest
        args:
        - "-text=Backend API Response"
        - "-listen=:8080"
        ports:
        - containerPort: 8080
          name: http
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: backend
spec:
  selector:
    app: backend
    tier: api
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
    name: http
EOF

echo "[setup] Creating Frontend deployment..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: frontend
  labels:
    app: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
      tier: web
  template:
    metadata:
      labels:
        app: frontend
        tier: web
    spec:
      containers:
      - name: frontend
        image: nginx:1.24
        ports:
        - containerPort: 80
          name: http
---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: frontend
spec:
  selector:
    app: frontend
    tier: web
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
EOF

echo "[setup] Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/backend -n backend 2>/dev/null || true
kubectl wait --for=condition=available --timeout=60s deployment/frontend -n frontend 2>/dev/null || true

echo "[setup] Setup complete!"
kubectl get pods -n frontend
kubectl get pods -n backend
