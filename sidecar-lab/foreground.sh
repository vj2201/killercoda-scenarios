#!/bin/bash
set -euo pipefail

echo "=================================================="
echo "=== CKA Sidecar Lab: Auto Setup (foreground)  ==="
echo "=== Start: $(date)                           ==="
echo "=================================================="

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

if kubectl get deploy wordpress >/dev/null 2>&1; then
  echo "[info] wordpress already exists"
else
  echo "[info] Applying base Deployment..."
  kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 1
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "WordPress app writing logs..." >> /var/log/wordpress.log; sleep 5; done
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
      volumes:
      - name: log-volume
        emptyDir: {}
YAML
fi

kubectl rollout status deploy/wordpress --timeout=120s || true
kubectl get deploy,po -l app=wordpress || true

echo "=================================================="
echo "=== Lab setup complete: $(date)                ==="
echo "=== Next: kubectl edit deploy wordpress ==="
echo "=== Add sidecar per step 2 instructions        ==="
echo "=================================================="
