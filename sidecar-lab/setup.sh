#!/bin/bash
set -e

echo "🚀 Setting up CKA Sidecar Practice Lab..."
echo "Creating base deployment (without sidecar)..."

# Wait for Kubernetes API to be ready (up to ~2 minutes)
echo "Waiting for Kubernetes API to become ready..."
for i in {1..60}; do
  if kubectl version --short >/dev/null 2>&1 && kubectl get nodes >/dev/null 2>&1; then
    echo "Kubernetes API is ready."
    break
  fi
  sleep 2
  if [ "$i" -eq 60 ]; then
    echo "Warning: Kubernetes API not ready yet, continuing anyway..."
  fi
done

# Make sure the directory exists
mkdir -p /tmp/repo/git/sidecar-lab/

# Write deployment YAML into the expected directory
cat <<EOF > /tmp/repo/git/sidecar-lab/synergy-deploy.yaml
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

# Apply the deployment
kubectl apply -f /tmp/repo/git/sidecar-lab/synergy-deploy.yaml

# Wait for the deployment to become available, but don't fail the script if it takes longer
kubectl rollout status deployment/synergy-deployment --timeout=120s || true

# Verify pod
kubectl get pods -l app=synergy

echo
echo "✅ Base deployment created!"
echo "Now edit the deployment to add a sidecar container using the same volume."
