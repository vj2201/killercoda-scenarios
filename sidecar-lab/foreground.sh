#!/bin/bash
set -euo pipefail

echo "=== Lab setup starting ($(date)) ==="

echo "[info] kubectl version:" || true
kubectl version || true

echo "[info] Waiting for a Ready node..."
for i in {1..90}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[info] Cluster Ready"
    break
  fi
  sleep 2
  if [ "$i" -eq 90 ]; then echo "[warn] Proceeding without Ready confirmation"; fi
done

if kubectl get deploy synergy-deployment >/dev/null 2>&1; then
  echo "[info] synergy-deployment already exists"
else
  echo "[info] Applying base Deployment..."
  kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synergy-deployment
  labels:
    app: synergy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: synergy
  template:
    metadata:
      labels:
        app: synergy
    spec:
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "Main app writing logs..." >> /var/log/synergy-deployment.log; sleep 5; done
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
      volumes:
      - name: log-volume
        emptyDir: {}
YAML
fi

kubectl rollout status deploy/synergy-deployment --timeout=120s || true
kubectl get deploy,po -l app=synergy || true

echo "=== Lab setup complete ($(date)) ==="

