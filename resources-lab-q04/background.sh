#!/bin/bash
set -e

echo "🚀 Setting up CKA Resources Practice (Q04)"

if kubectl get deploy wordpress >/dev/null 2>&1; then
  echo "[info] Deployment 'wordpress' already exists"
else
  echo "[info] Creating base wordpress deployment (replicas=3, with initContainer)"
  kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 3
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      initContainers:
      - name: init-setup
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args: ["echo init done; sleep 1"]
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "WordPress app running..."; sleep 5; done
YAML
fi

echo "✅ Setup complete. Resources are being created..."

