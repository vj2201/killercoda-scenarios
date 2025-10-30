# Network Policy - Complete Solution

## Task Summary

Create a least-permissive network policy to allow frontend deployment to communicate with backend deployment.

- Frontend: `frontend` namespace
- Backend: `backend` namespace

---

## Step 1: Understand the Setup

Check the existing deployments:

```bash
kubectl get pods -n frontend
kubectl get pods -n backend
```

View the labels on backend pods:

```bash
kubectl get pods -n backend --show-labels
```

You should see labels: `app=backend,tier=api`

Check the namespace label:

```bash
kubectl get ns frontend --show-labels
```

You should see: `kubernetes.io/metadata.name=frontend`

---

## Step 2: Test Current Connectivity

Before creating the network policy, test that connectivity works:

```bash
# Get frontend pod name
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')

# Test connection to backend
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

Expected output: `Backend API Response`

---

## Step 3: Create the Network Policy

### Understanding Least Permissive

A least-permissive network policy should:
1. Apply to backend pods (using `podSelector`)
2. Allow ingress only from frontend namespace (using `namespaceSelector`)
3. Allow only port 8080 (using `ports`)
4. Deny everything else (implicit when NetworkPolicy exists)

### Create the Policy

**Important Notes:**
- Network policy must be created in the **backend** namespace (where the protected pods are)
- Use `podSelector` to select backend pods by their labels
- Use `namespaceSelector` to allow traffic only from frontend namespace
- Specify exact port (8080)

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

### Breakdown:

- **metadata.namespace: backend** - Policy is in backend namespace
- **spec.podSelector** - Selects backend pods with labels `app=backend` and `tier=api`
- **spec.policyTypes: [Ingress]** - This policy controls incoming traffic
- **spec.ingress[0].from[0].namespaceSelector** - Allows traffic from frontend namespace
- **spec.ingress[0].ports** - Only allows TCP port 8080

---

## Step 4: Verify the Network Policy

Check the policy was created:

```bash
kubectl get networkpolicy -n backend
```

View details:

```bash
kubectl describe networkpolicy backend-network-policy -n backend
```

Expected output should show:
- **PodSelector:** app=backend,tier=api
- **Allowing ingress traffic:** From namespaces with label `kubernetes.io/metadata.name=frontend`
- **To Port:** 8080/TCP

---

## Step 5: Test the Network Policy

### Test 1: Frontend should still access backend (allowed)

```bash
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

Expected: `Backend API Response` ✅

### Test 2: Default namespace should NOT access backend (denied)

```bash
kubectl run test-pod --image=busybox:1.36 --rm -it --restart=Never -- \
  wget -qO- --timeout=2 http://backend-service.backend:8080
```

Expected: Timeout/failure ❌

If it fails with "wget: can't connect", that's correct - the network policy is blocking it.

### Test 3: Verify from another pod in default namespace

```bash
kubectl run test-pod --image=nicolaka/netshoot --rm -it --restart=Never -- \
  curl --max-time 2 http://backend-service.backend:8080
```

Expected: Timeout ❌

---

## Alternative: Using kubectl create (if available in newer versions)

Some newer kubectl versions support:

```bash
kubectl create networkpolicy backend-network-policy \
  --namespace backend \
  --ingress \
  --from-namespace frontend \
  --ports 8080
```

However, this may not give you the same level of control over pod selectors, so YAML is recommended.

---

## Verification Checklist

- ✅ Network policy exists in backend namespace
- ✅ Policy name: `backend-network-policy`
- ✅ Pod selector matches backend pods: `app=backend,tier=api`
- ✅ Policy type: Ingress
- ✅ Ingress from: frontend namespace only
- ✅ Allowed port: 8080/TCP
- ✅ Frontend pods can access backend service
- ✅ Default namespace pods cannot access backend service

---

## Common Mistakes to Avoid

1. **Wrong namespace** - Policy must be in backend namespace (where protected pods are)
2. **Wrong pod selector** - Must match backend pod labels exactly
3. **Wrong namespace selector** - Use `kubernetes.io/metadata.name: frontend`
4. **Missing port specification** - Must specify port 8080
5. **Wrong policy type** - Use `Ingress` (not `Egress`)

---

## Key Points

**Network Policy Principles:**
- NetworkPolicy is namespace-scoped
- Must be created in the namespace of the pods you want to protect
- Once a pod is selected by any NetworkPolicy, all traffic is denied except what's explicitly allowed
- Multiple NetworkPolicies can select the same pods (rules are additive)

**Least Permissive Means:**
- Only allow traffic from the specific namespace (frontend)
- Only allow the specific port needed (8080)
- Implicitly deny everything else

**Namespace Selector:**
- Kubernetes automatically labels namespaces with `kubernetes.io/metadata.name=<namespace-name>`
- Use this label in `namespaceSelector.matchLabels`

---

## Troubleshooting

**If frontend cannot access backend after applying policy:**

1. Check policy exists and is in correct namespace:
   ```bash
   kubectl get networkpolicy -n backend
   ```

2. Verify pod selector matches backend pods:
   ```bash
   kubectl get pods -n backend --show-labels
   kubectl describe networkpolicy backend-network-policy -n backend
   ```

3. Check namespace label:
   ```bash
   kubectl get ns frontend --show-labels
   ```

4. Verify port is correct:
   ```bash
   kubectl get svc -n backend
   ```

**If default namespace can still access backend:**

- Ensure the NetworkPolicy was created in the backend namespace
- Verify the `from` clause uses `namespaceSelector` not `podSelector`

---

## Time-Saving Tips for CKA Exam

1. **Use kubectl explain** for syntax:
   ```bash
   kubectl explain networkpolicy.spec
   kubectl explain networkpolicy.spec.ingress
   ```

2. **Get examples from existing NetworkPolicies** (if any):
   ```bash
   kubectl get networkpolicy -A -o yaml
   ```

3. **Test immediately** after creating - don't wait until the end

4. **Use short names**:
   ```bash
   kubectl get netpol -n backend
   ```

---

**Congratulations!** You've created a least-permissive network policy that allows only necessary traffic.
