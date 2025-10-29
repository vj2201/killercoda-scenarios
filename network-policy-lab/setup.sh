#!/bin/bash
set -euo pipefail

echo "[setup] NetworkPolicy lab: preparing namespaces and workloads"

# Wait for a Ready node
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    break
  fi
  sleep 2
done

kubectl get ns frontend >/dev/null 2>&1 || kubectl create ns frontend
kubectl get ns backend  >/dev/null 2>&1 || kubectl create ns backend

echo "[setup] Deploying backend (echo on 5678)"
kubectl apply -f - <<'YAML'
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
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: echo
        image: hashicorp/http-echo:1.0.0
        args:
          - "-text=Backend OK"
        ports:
        - name: http
          containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: backend-svc
  namespace: backend
  labels:
    app: backend
spec:
  selector:
    app: backend
  ports:
  - name: http
    port: 5678
    targetPort: 5678
YAML

echo "[setup] Deploying frontend (curl image)"
kubectl apply -f - <<'YAML'
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
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: curl
        image: curlimages/curl:8.5.0
        command: ["sh","-c"]
        args: ["sleep 36000"]
YAML

echo "[setup] Creating candidate NetworkPolicies in /root/network-policies"
mkdir -p /root/network-policies

cat >/root/network-policies/allow-frontend-to-backend-strict.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
      podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 5678
YAML

cat >/root/network-policies/allow-frontend-namespace-to-backend.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-namespace-to-backend
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
    ports:
    - protocol: TCP
      port: 5678
YAML

cat >/root/network-policies/allow-all-to-backend.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-all-to-backend
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - {}
YAML

echo "[setup] Waiting for deployments to be ready (best-effort)"
kubectl -n backend  rollout status deploy/backend  --timeout=120s || true
kubectl -n frontend rollout status deploy/frontend --timeout=120s || true

echo "[setup] Done"

