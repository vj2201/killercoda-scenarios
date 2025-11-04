# Solution

## Step 1: Create Gateway
```bash
kubectl create namespace web-migration
cat > /tmp/gateway.yaml << EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: web-migration
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    port: 443
    protocol: HTTPS
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - name: web-tls
EOF
kubectl apply -f /tmp/gateway.yaml
```

## Step 2: Create HTTPRoute
```bash
cat > /tmp/httproute.yaml << EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-migration
spec:
  parentRefs:
  - name: web-gateway
    namespace: web-migration
  hostnames:
  - gateway.web.k8s.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: web-svc
      port: 80
  - matches:
    - path:
        type: PathPrefix
        value: /api
    backendRefs:
    - name: api-svc
      port: 8080
EOF
kubectl apply -f /tmp/httproute.yaml
kubectl get gateway,httproute -n web-migration
```

## Explanation
Gateway API separates listener configuration (Gateway) from routing logic (HTTPRoute), providing cleaner management of multiple backends and TLS settings. This is more modular than traditional Ingress resources.

✅ **Done!** Gateway API resources created and routing configured successfully.
