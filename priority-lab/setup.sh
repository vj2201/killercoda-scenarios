#!/bin/bash
set -euo pipefail

echo "🚀 Setting up CKA Priority Class Practice Lab" >&2

echo "[info] Waiting for Kubernetes API & Ready node..." >&2
for i in {1..120}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[info] Cluster Ready" >&2
    break
  fi
  sleep 2
  if [ "$i" -eq 120 ]; then
    echo "[warn] Proceeding without Ready confirmation" >&2
  fi
done

# Additional wait for API server to be fully ready
echo "[info] Waiting for API server to be fully ready..." >&2
sleep 5

# Create namespace
echo "[info] Creating priority namespace..." >&2
kubectl get ns priority >/dev/null 2>&1 || kubectl create ns priority

# Create user-defined PriorityClasses
echo "[info] Creating user-defined PriorityClasses..." >&2
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
echo "[info] Creating busybox-logger deployment..." >&2
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
        image: registry.k8s.io/busybox:1.36.1
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "$(date): Logging message"; sleep 10; done
YAML

echo "[info] Waiting for deployment rollout..." >&2
kubectl rollout status deploy/busybox-logger -n priority --timeout=120s 2>&1 || echo "[warn] Rollout timed out, but continuing..." >&2

echo "[info] Current resources:" >&2
kubectl get priorityclass 2>&1 | grep -E "medium-priority|normal-priority" || echo "[warn] PriorityClasses not found" >&2
kubectl get deploy,po -n priority 2>&1 || echo "[warn] Deployment not found" >&2

echo "✅ Setup complete. Proceed to Step 1." >&2
