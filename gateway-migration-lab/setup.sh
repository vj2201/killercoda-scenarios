#!/bin/bash
set -euo pipefail

echo "[setup] Creating namespace..."
kubectl create namespace web-app 2>/dev/null || true

echo "[setup] Installing Gateway API CRDs..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml 2>/dev/null || true

echo "[setup] Waiting for Gateway API CRDs..."
sleep 5

echo "[setup] Creating GatewayClass..."
kubectl apply -f - <<'EOF'
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-class
spec:
  controllerName: example.com/gateway-controller
  description: "NGINX Gateway Controller"
EOF

echo "[setup] Creating backend web application..."
kubectl apply -f - <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  namespace: web-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: hashicorp/http-echo:latest
        args:
        - "-text=Welcome to the Web Application"
        - "-listen=:8080"
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
  namespace: web-app
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
EOF

echo "[setup] Generating TLS certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=gateway.web.k8s.local/O=WebApp" 2>/dev/null

echo "[setup] Creating TLS Secret..."
kubectl create secret tls web-tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n web-app \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating existing Ingress resource..."
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  namespace: web-app
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - gateway.web.k8s.local
    secretName: web-tls-secret
  rules:
  - host: gateway.web.k8s.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
EOF

echo "[setup] Waiting for deployment..."
kubectl wait --for=condition=available --timeout=60s deployment/web-app -n web-app 2>/dev/null || true

echo "[setup] Setup complete!"
echo ""
echo "Existing resources created:"
kubectl get ingress -n web-app
kubectl get pods -n web-app
echo ""
echo "GatewayClass available:"
kubectl get gatewayclass
