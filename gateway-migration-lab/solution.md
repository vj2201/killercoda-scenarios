# Solution

## Step 0: Inspect Existing Ingress (What We're Migrating From)

First, examine the current Ingress resource to understand what we need to replicate:

```bash
kubectl get ingress web -n web-app -o yaml
```

**Key information to extract:**

```yaml
spec:
  ingressClassName: nginx           # ← We'll use GatewayClass instead
  tls:
  - hosts:
    - gateway.web.k8s.local         # ← Hostname (use in Gateway)
    secretName: web-tls-secret      # ← TLS secret (use in Gateway)
  rules:
  - host: gateway.web.k8s.local     # ← Same hostname
    http:
      paths:
      - path: /                     # ← Path (use in HTTPRoute)
        pathType: Prefix
        backend:
          service:
            name: web-service       # ← Backend service (use in HTTPRoute)
            port:
              number: 80            # ← Backend port (use in HTTPRoute)
```

**What we learned:**
- Hostname: `gateway.web.k8s.local`
- TLS Secret: `web-tls-secret`
- Backend: `web-service:80`
- Path: `/` (all traffic)

Now let's create equivalent Gateway API resources!

---

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

**Mapping from Ingress:**
- `rules[0].host` → `hostnames`
- `rules[0].http.paths[0].backend.service.name` → `backendRefs[0].name`
- `rules[0].http.paths[0].backend.service.port` → `backendRefs[0].port`

```bash
cat > /tmp/httproute.yaml << EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-app
spec:
  parentRefs:
  - name: web-gateway              # ← Attach to the Gateway we created
    namespace: web-app
  hostnames:
  - gateway.web.k8s.local          # ← Same hostname from Ingress
  rules:
  - backendRefs:
    - name: web-service            # ← Same backend service from Ingress
      port: 80                     # ← Same port from Ingress
EOF
kubectl apply -f /tmp/httproute.yaml
```

**Verify both resources:**
```bash
# Check Gateway status
kubectl get gateway web-gateway -n web-app
kubectl describe gateway web-gateway -n web-app

# Check HTTPRoute status
kubectl get httproute web-route -n web-app
kubectl describe httproute web-route -n web-app
```

**Expected status:**
- Gateway: `Programmed=True`
- HTTPRoute: `Accepted=True`

---

## Step 3: (Optional) Compare Old vs New

**View side-by-side:**
```bash
# Old way (Ingress)
kubectl get ingress web -n web-app

# New way (Gateway API)
kubectl get gateway,httproute -n web-app
```

**Once confirmed working, you could delete the Ingress:**
```bash
kubectl delete ingress web -n web-app
```

---

## Migration Summary

| **Ingress Field** | **Gateway API Equivalent** | **Resource** |
|-------------------|---------------------------|--------------|
| `spec.ingressClassName` | `spec.gatewayClassName` | Gateway |
| `spec.tls.hosts` | `spec.listeners[].hostname` | Gateway |
| `spec.tls.secretName` | `spec.listeners[].tls.certificateRefs` | Gateway |
| `spec.rules[].host` | `spec.hostnames[]` | HTTPRoute |
| `spec.rules[].http.paths[].backend.service` | `spec.rules[].backendRefs[]` | HTTPRoute |

## Explanation

**Gateway API** provides cleaner **separation of concerns**:
- **Gateway** = Infrastructure (listeners, ports, TLS) → managed by **cluster admin**
- **HTTPRoute** = Routing rules (paths, backends) → managed by **app developer**

Both resources must be in the **same namespace**, and HTTPRoute attaches to Gateway via `parentRefs`.

✅ **Done!** Successfully migrated from Ingress to Gateway API.
