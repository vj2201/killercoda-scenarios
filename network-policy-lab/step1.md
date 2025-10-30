## Task: Create Least-Permissive Network Policy

Verify the current setup:

```bash
kubectl get pods -n frontend
kubectl get pods -n backend
```

Test connectivity (before network policy - should work):

```bash
# Get a frontend pod name
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')

# Test connection from frontend to backend service
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

This should return: `Backend API Response`

---

## Create Network Policy

Create a network policy in the **backend** namespace that:

1. Selects the backend pods
2. Allows ingress traffic **only** from frontend namespace pods
3. Allows traffic **only** on port 8080
4. Denies all other traffic (least permissive)

<details>
<summary>💡 Hint: Network Policy Structure</summary>

A least-permissive network policy should:
- Use `podSelector` to select backend pods by label
- Use `namespaceSelector` in ingress rules to allow only from frontend namespace
- Specify the exact port (8080) in the ports section
- By default, NetworkPolicy denies all traffic not explicitly allowed

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-network-policy
  namespace: backend
spec:
  podSelector:
    matchLabels:
      # Select backend pods
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          # Select frontend namespace
    ports:
    - protocol: TCP
      port: 8080
```

**Key points:**
- Network policy must be in the **backend** namespace
- Use labels to select pods: `app: backend` and `tier: api`
- Use namespace selector: `kubernetes.io/metadata.name: frontend`
- Only allow port 8080

</details>

---

## Create the Network Policy

**Option 1: Using kubectl with YAML**

```bash
kubectl apply -f - <<EOF
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

**Option 2: Save to file and apply**

Create `backend-netpol.yaml` and apply with `kubectl apply -f backend-netpol.yaml`

---

## Verify the Network Policy

Check the network policy exists:

```bash
kubectl get networkpolicy -n backend
kubectl describe networkpolicy backend-network-policy -n backend
```

Test connectivity (should still work):

```bash
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

Test from a different namespace (should fail):

```bash
# Create a test pod in default namespace
kubectl run test-pod --image=busybox:1.36 --rm -it --restart=Never -- \
  wget -qO- --timeout=2 http://backend-service.backend:8080
```

This should timeout/fail because the default namespace is not allowed.

---

**Success criteria:**
- ✅ Network policy exists in backend namespace
- ✅ Policy selects backend pods (app=backend, tier=api)
- ✅ Policy allows ingress from frontend namespace only
- ✅ Policy allows only port 8080
- ✅ Frontend can access backend
- ✅ Other namespaces cannot access backend

You've successfully created a least-permissive network policy!
