#!/bin/bash
set -euo pipefail

echo "[setup] Waiting for Kubernetes cluster..." >&2
for i in {1..60}; do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[setup] Cluster ready" >&2
    break
  fi
  sleep 2
done

echo "[setup] Creating namespace..." >&2
kubectl create namespace web-app 2>/dev/null || true

echo "[setup] Installing Gateway API CRDs..." >&2
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml

echo "[setup] Waiting for Gateway API CRDs to be established..." >&2
for i in {1..30}; do
  if kubectl get crd gateways.gateway.networking.k8s.io >/dev/null 2>&1 && \
     kubectl get crd httproutes.gateway.networking.k8s.io >/dev/null 2>&1 && \
     kubectl get crd gatewayclasses.gateway.networking.k8s.io >/dev/null 2>&1; then
    echo "[setup] Gateway API CRDs ready" >&2
    break
  fi
  echo "[setup] Waiting for CRDs... (attempt $i/30)" >&2
  sleep 2
done

# Additional wait for CRD to be fully established
sleep 3

echo "[setup] Verifying CRDs:" >&2
kubectl get crd | grep gateway >&2 || echo "[warn] Gateway CRDs not found!" >&2

echo "[setup] Creating GatewayClass..." >&2
kubectl apply -f - <<'EOF'
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: nginx-class
spec:
  controllerName: example.com/gateway-controller
  description: "NGINX Gateway Controller"
EOF

echo "[setup] Creating backend web application..." >&2
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

echo "[setup] Generating TLS certificate..." >&2
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=gateway.web.k8s.local/O=WebApp" 2>/dev/null

echo "[setup] Creating TLS Secret..." >&2
kubectl create secret tls web-tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n web-app \
  --dry-run=client -o yaml | kubectl apply -f -

echo "[setup] Creating existing Ingress resource..." >&2
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

echo "[setup] Waiting for deployment..." >&2
kubectl wait --for=condition=available --timeout=60s deployment/web-app -n web-app 2>/dev/null || true

echo "[setup] Setup complete!" >&2
echo "" >&2
echo "Existing resources created:" >&2
kubectl get ingress -n web-app >&2
kubectl get pods -n web-app >&2
echo "" >&2
echo "Gateway API CRDs:" >&2
kubectl get crd | grep gateway >&2
echo "" >&2
echo "GatewayClass available:" >&2
kubectl get gatewayclass >&2
