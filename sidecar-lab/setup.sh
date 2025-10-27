#!/bin/bash
set -e

echo "🚀 Setting up CKA Sidecar Practice Lab..."
echo "Creating base deployment (without sidecar)..."

cat <<EOF > ~/synergy-deploy.yaml
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

kubectl apply -f ~/synergy-deploy.yaml
kubectl get pods -l app=synergy

echo
echo "✅ Base deployment created!"
echo "Now edit the deployment to add a sidecar container using the same volume."
