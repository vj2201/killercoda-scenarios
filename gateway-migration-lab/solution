# Solution

## Step 0: Inspect Existing Ingress (What We're Migrating From)

First, examine the current Ingress resource to understand what we need to replicate.

### Finding TLS Values - Command Comparison

**Option 1: Get full YAML (most complete)**
```bash
kubectl get ingress web -n web-app -o yaml
```
✅ Shows **everything**: hostname, TLS secret, backend service, paths
✅ Best for copying exact field values

**Option 2: Describe (human-readable)**
```bash
kubectl describe ingress web -n web-app
```
✅ Shows TLS section clearly with hosts and secret name
✅ Better formatted, easier to read
✅ Shows Rules and Backend sections clearly

**Option 3: Get (basic info only)**
```bash
kubectl get ingress web -n web-app
```
❌ **Does NOT show TLS details** - only shows NAME, CLASS, HOSTS, ADDRESS, PORTS, AGE
❌ Not useful for finding secret name

**Option 4: Check if secret exists**
```bash
kubectl get secret web-tls-secret -n web-app
```
✅ Confirms the TLS secret exists
❌ **Does NOT show** what's inside the certificate
💡 Only use this to verify the secret is available after you found its name from Ingress

---

**Recommended approach: Use `kubectl describe ingress`**

```bash
kubectl describe ingress web -n web-app
```

**Example output:**
```
Name:             web
Namespace:        web-app
Ingress Class:    nginx
Rules:
  Host                    Path  Backends
  ----                    ----  --------
  gateway.web.k8s.local
                          /     web-service:80
TLS:
  web-tls-secret terminates gateway.web.k8s.local   ← FOUND IT!
```

**Or use YAML for complete details:**

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

**Before creating, understand the TLS field mappings:**

### Where Do TLS Fields Come From?

**From Ingress inspection:**
```yaml
# Ingress (old way)
spec:
  tls:
  - hosts:
    - gateway.web.k8s.local         # ← hostname
    secretName: web-tls-secret      # ← certificate name
```

**Maps to Gateway API (new way):**
```yaml
# Gateway (new way)
spec:
  listeners:
  - hostname: gateway.web.k8s.local  # ← From Ingress tls.hosts
    tls:
      mode: Terminate               # ← NEW: How to handle TLS (not in Ingress)
      certificateRefs:
      - name: web-tls-secret        # ← From Ingress tls.secretName
```

**TLS Field Explanations:**

| **Field** | **Where It Comes From** | **Why This Value?** |
|-----------|------------------------|---------------------|
| `hostname: gateway.web.k8s.local` | From Ingress `spec.tls[].hosts[]` | Same hostname as Ingress |
| `tls.mode: Terminate` | **Not in Ingress** (implicit behavior) | Gateway decrypts HTTPS → sends HTTP to backend |
| `certificateRefs[].name: web-tls-secret` | From Ingress `spec.tls[].secretName` | Same TLS certificate secret |
| `certificateRefs[].kind: Secret` | **Not in Ingress** (implicit) | Gateway API requires explicit kind (default: Secret) |

**What is "Terminate" mode?**
- Gateway terminates (decrypts) HTTPS traffic at port 443
- Forwards unencrypted HTTP to backend service
- Same behavior as Ingress (Ingress doesn't have this field, it's always "terminate")

**Other TLS modes (not used here):**
- `Passthrough`: Gateway forwards encrypted traffic without decrypting (raw TCP)
- For this lab, we use `Terminate` to match Ingress behavior

---

**Now create the Gateway:**

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
    hostname: gateway.web.k8s.local   # ← From Ingress tls.hosts
    tls:
      mode: Terminate                 # ← NEW field (not in Ingress, but same behavior)
      certificateRefs:
      - name: web-tls-secret          # ← From Ingress tls.secretName
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

| **Ingress Field** | **Gateway API Equivalent** | **Resource** | **Notes** |
|-------------------|---------------------------|--------------|-----------|
| `spec.ingressClassName` | `spec.gatewayClassName` | Gateway | Same purpose: select controller |
| `spec.tls.hosts[]` | `spec.listeners[].hostname` | Gateway | Move hostname to listener level |
| `spec.tls.secretName` | `spec.listeners[].tls.certificateRefs[].name` | Gateway | Same secret, explicit reference |
| *(implicit: terminate TLS)* | `spec.listeners[].tls.mode: Terminate` | Gateway | **NEW**: Explicitly declare TLS behavior |
| `spec.rules[].host` | `spec.hostnames[]` | HTTPRoute | Move routing host to HTTPRoute |
| `spec.rules[].http.paths[].backend.service` | `spec.rules[].backendRefs[]` | HTTPRoute | Same backend, cleaner syntax |

**Key Differences:**
- **Ingress**: TLS termination is implicit (always terminates)
- **Gateway API**: TLS `mode` is explicit (`Terminate`, `Passthrough`, etc.)
- **Gateway API**: Separates infrastructure (Gateway) from routing (HTTPRoute)

## Explanation

**Gateway API** provides cleaner **separation of concerns**:
- **Gateway** = Infrastructure (listeners, ports, TLS) → managed by **cluster admin**
- **HTTPRoute** = Routing rules (paths, backends) → managed by **app developer**

Both resources must be in the **same namespace**, and HTTPRoute attaches to Gateway via `parentRefs`.

✅ **Done!** Successfully migrated from Ingress to Gateway API.
