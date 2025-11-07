#!/bin/bash
set -e

echo "🚀 Setting up CKA Sidecar Practice Lab..."
echo "Creating base deployment (without sidecar)..."
kubectl apply -f - <<'EOF'
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
EOF

echo
echo "✅ Base deployment created!"
echo "Now edit the deployment to add a sidecar container using the same volume."
