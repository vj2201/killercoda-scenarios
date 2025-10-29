#!/bin/bash
set -e

echo "🚀 Setting up CKA Resources Practice (Q04)"

echo "[info] Waiting for Kubernetes API & Ready node..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[info] Cluster Ready"
    break
  fi
  sleep 2
  if [ "$i" -eq 90 ]; then echo "[warn] Proceeding without Ready confirmation"; fi
done

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

kubectl rollout status deploy/wordpress --timeout=120s || true
kubectl get deploy,po -l app=wordpress || true

echo "✅ Setup complete. Proceed to Step 1."

