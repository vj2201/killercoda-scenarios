#!/bin/bash
set -e

echo "🚀 Setting up CKA Priority Class Practice Lab"

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
echo "[info] Creating priority namespace..."
kubectl get ns priority >/dev/null 2>&1 || kubectl create ns priority

# Create user-defined PriorityClasses
echo "[info] Creating user-defined PriorityClasses..."
kubectl apply -f - <<'YAML'
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: medium-priority
value: 1000
globalDefault: false
description: "Medium priority for important workloads"
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: normal-priority
value: 500
globalDefault: false
description: "Normal priority for regular workloads"
YAML

# Create busybox-logger deployment without priorityClassName
echo "[info] Creating busybox-logger deployment..."
kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-logger
  namespace: priority
  labels:
    app: busybox-logger
spec:
  replicas: 2
  selector:
    matchLabels:
      app: busybox-logger
  template:
    metadata:
      labels:
        app: busybox-logger
    spec:
      containers:
      - name: logger
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "$(date): Logging message"; sleep 10; done
YAML

kubectl rollout status deploy/busybox-logger -n priority --timeout=120s || true
kubectl get deploy,po -n priority || true

echo "✅ Setup complete. Proceed to Step 1."
