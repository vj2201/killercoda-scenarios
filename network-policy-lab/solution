# Solution

## Step 0: Discover Required NetworkPolicy Fields

Before creating the NetworkPolicy, inspect the existing resources to find the required labels and ports:

### 1. Find Pod Labels (for podSelector)

```bash
# Check backend pod labels
kubectl get pods -n backend --show-labels
```

**Look for:**
```
NAME                       READY   STATUS    LABELS
backend-xxx-yyy            1/1     Running   app=backend,tier=api,...
```

Or use describe for detailed info:
```bash
kubectl describe deployment backend -n backend | grep -A 5 "Labels:"
```

**What we learned:**
- Pod labels: `app=backend`, `tier=api` (use these in `podSelector.matchLabels`)

### 2. Find Namespace Labels (for namespaceSelector)

```bash
# Check frontend namespace labels
kubectl get namespace frontend -o yaml
```

**Look for:**
```yaml
metadata:
  labels:
    kubernetes.io/metadata.name: frontend  # ← Use this label!
  name: frontend
```

**What we learned:**
- Namespace label: `kubernetes.io/metadata.name: frontend` (use in `namespaceSelector.matchLabels`)

### 3. Find Container Port (for ingress ports)

```bash
# Check what port the backend service/pod is using
kubectl get svc -n backend
kubectl describe deployment backend -n backend | grep -A 3 "Ports:"
```

Or check the deployment directly:
```bash
kubectl get deployment backend -n backend -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}'
```

**What we learned:**
- Container port: `8080` (use in `ingress.ports`)

---

## Step 1: Create NetworkPolicy

```bash
kubectl apply -f - <<'EOF'
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-network-policy
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend
      tier: api
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
    ports:
    - protocol: TCP
      port: 8080
EOF
```

**Verify:**
```bash
kubectl get networkpolicy -n backend
kubectl describe networkpolicy backend-network-policy -n backend
```

## Test Connectivity

```bash
# Should succeed (frontend → backend:8080)
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=2 http://backend-service.backend:8080

# Should fail (different namespace without selector)
kubectl run test-pod --image=busybox --rm -it -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

## Explanation

**NetworkPolicy** controls traffic at IP/port level. This policy uses:
- `podSelector`: Targets backend pods
- `namespaceSelector`: Allows only frontend namespace
- `ports`: Restricts to port 8080 only
- `policyTypes: [Ingress]`: Creates default deny for ingress

---

## Field Mapping Summary

| **What You Need** | **Where to Find It** | **NetworkPolicy Field** |
|-------------------|---------------------|------------------------|
| Pod labels | `kubectl get pods -n backend --show-labels` | `spec.podSelector.matchLabels` |
| Namespace labels | `kubectl get namespace frontend -o yaml` | `spec.ingress[].from[].namespaceSelector.matchLabels` |
| Container port | `kubectl get svc -n backend` or `kubectl describe deploy` | `spec.ingress[].ports[].port` |

**How inspection maps to NetworkPolicy:**

```yaml
# From: kubectl get pods -n backend --show-labels
# Discovered: app=backend, tier=api
spec:
  podSelector:
    matchLabels:
      app: backend      # ← From pod labels
      tier: api         # ← From pod labels

# From: kubectl get namespace frontend -o yaml
# Discovered: kubernetes.io/metadata.name: frontend
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend  # ← From namespace labels

# From: kubectl get svc -n backend (or deployment port)
# Discovered: port 8080
    ports:
    - protocol: TCP
      port: 8080       # ← From service/container port
```

✅ **Done!** Only frontend namespace can reach backend on port 8080.
