# Solution

## Step 1: Create Gateway in web-app Namespace
```bash
cat > /tmp/gateway.yaml << EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: web-app
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
      - name: web-tls-secret
EOF
kubectl apply -f /tmp/gateway.yaml
kubectl get gateway -n web-app
```

## Step 2: Create HTTPRoute in web-app Namespace
```bash
cat > /tmp/httproute.yaml << EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-app
spec:
  parentRefs:
  - name: web-gateway
    namespace: web-app
  hostnames:
  - gateway.web.k8s.local
  rules:
  - backendRefs:
    - name: backend
      port: 8080
EOF
kubectl apply -f /tmp/httproute.yaml
kubectl get httproute -n web-app
kubectl describe gateway web-gateway -n web-app
```

## Explanation
Gateway API provides a cleaner separation between infrastructure configuration (Gateway) and routing rules (HTTPRoute). Both resources must be in the same namespace and the HTTPRoute references the Gateway via parentRefs.

✅ **Done!** Successfully migrated from Ingress to Gateway API.
