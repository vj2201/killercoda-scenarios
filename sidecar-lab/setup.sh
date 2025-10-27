#!/bin/bash
set -e

echo "🚀 Setting up CKA Sidecar Practice Lab..."
echo "Creating base deployment (without sidecar)..."

# Wait for Kubernetes API and nodes to be ready (up to ~3 minutes)
echo "Waiting for Kubernetes API to become ready..."
for i in {1..90}; do
  if kubectl version >/dev/null 2>&1; then
    if kubectl get nodes >/dev/null 2>&1; then
      # Try to ensure at least one node is Ready
      if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
        echo "Kubernetes API and node(s) are ready."
        break
      fi
    fi
  fi
  sleep 2
  if [ "$i" -eq 90 ]; then
    echo "Warning: Kubernetes not fully ready yet, continuing anyway..."
  fi
done

echo "Applying base Deployment manifest..."
kubectl apply -f - <<'EOF'
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
EOF

# Wait for the deployment to become available, but don't fail the script if it takes longer
kubectl rollout status deployment/synergy-deployment --timeout=120s || true

# Verify pod
kubectl get deploy,po -l app=synergy || true

echo
echo "✅ Base deployment created!"
echo "Now edit the deployment to add a sidecar container using the same volume."
