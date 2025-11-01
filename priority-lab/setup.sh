#!/bin/bash
set -e

echo "🚀 Setting up CKA Priority Class Practice Lab" >&2

# Create namespace
echo "[info] Creating priority namespace..." >&2
kubectl create namespace priority --dry-run=client -o yaml | kubectl apply -f -

# Create user-defined PriorityClasses
echo "[info] Creating user-defined PriorityClasses..." >&2
cat <<EOF | kubectl apply -f -
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
EOF

# Create busybox-logger deployment without priorityClassName
echo "[info] Creating busybox-logger deployment..." >&2
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busybox-logger
  namespace: priority
  labels:
    app: busybox-logger
spec:
  replicas: 1
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
        image: busybox
        command: ["sh", "-c"]
        args:
          - "while true; do echo \$(date): Logging message; sleep 10; done"
EOF

echo "✅ Setup complete. Resources are being created..." >&2
