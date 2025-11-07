#!/bin/bash
set -e

echo "[setup] Creating nginx-static namespace..."
kubectl create namespace nginx-static --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Generating TLS certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=ckaquestion.k8s.local/O=CKA-Lab" 2>/dev/null

echo "[setup] Creating TLS Secret..."
kubectl create secret tls nginx-tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n nginx-static \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating nginx ConfigMap with TLSv1.2 and TLSv1.3..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
  namespace: nginx-static
data:
  nginx.conf: |
    user nginx;
    worker_processes auto;
    error_log /var/log/nginx/error.log;
    pid /run/nginx.pid;

    events {
        worker_connections 1024;
    }

    http {
        log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for"';

        access_log /var/log/nginx/access.log main;

        server {
            listen 443 ssl;
            server_name ckaquestion.k8s.local;

            ssl_certificate /etc/nginx/ssl/tls.crt;
            ssl_certificate_key /etc/nginx/ssl/tls.key;
            ssl_protocols TLSv1.2 TLSv1.3;
            ssl_prefer_server_ciphers on;

            location / {
                return 200 'TLS Configuration Working!\n';
                add_header Content-Type text/plain;
            }
        }
    }
EOF

echo "[setup] Creating nginx Deployment..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-static
  namespace: nginx-static
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-static
  template:
    metadata:
      labels:
        app: nginx-static
    spec:
      containers:
      - name: nginx
        image: nginx:1.24
        ports:
        - containerPort: 443
          name: https
        volumeMounts:
        - name: nginx-config-volume
          mountPath: /etc/nginx/nginx.conf
          subPath: nginx.conf
        - name: tls-secret-volume
          mountPath: /etc/nginx/ssl
          readOnly: true
      volumes:
      - name: nginx-config-volume
        configMap:
          name: nginx-config
      - name: tls-secret-volume
        secret:
          secretName: nginx-tls-secret
EOF

echo "[setup] Creating nginx Service..."
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  namespace: nginx-static
spec:
  type: ClusterIP
  selector:
    app: nginx-static
  ports:
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
EOF

echo "[setup] Setup complete! Resources are being created..."
