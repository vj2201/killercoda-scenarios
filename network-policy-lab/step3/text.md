# Step 3: Test Network Isolation

Now let's verify that the NetworkPolicy is working correctly by testing connectivity from different sources.

## Test 1: Frontend → Backend (Should SUCCEED)

The frontend pod should be able to reach the backend on port 8080:

```bash
FRONTEND_POD=$(kubectl get pod -n frontend -l app=frontend -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n frontend $FRONTEND_POD -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

**Expected:** You should see a response from the backend service.

---

## Test 2: Other Namespace → Backend (Should FAIL)

Pods from other namespaces should be blocked:

```bash
kubectl run test-pod --image=busybox --rm -it -- wget -qO- --timeout=2 http://backend-service.backend:8080
```

**Expected:** Connection should timeout or fail (policy blocks it).

---

## Understanding the Results

✅ **Test 1 Success:** The NetworkPolicy allows traffic from the frontend namespace
❌ **Test 2 Failure:** The NetworkPolicy blocks traffic from other namespaces

This is exactly what we wanted! The backend is now secured and only accessible from the frontend.

---

## Field Mapping Summary

Here's how your discovered values mapped to the NetworkPolicy:

| **Discovered Value** | **Source Command** | **NetworkPolicy Field** |
|---------------------|-------------------|------------------------|
| `app=backend, tier=api` | `kubectl get pods -n backend --show-labels` | `spec.podSelector.matchLabels` |
| `kubernetes.io/metadata.name: frontend` | `kubectl get namespace frontend -o yaml` | `spec.ingress[].from[].namespaceSelector.matchLabels` |
| `8080` | `kubectl get svc -n backend` | `spec.ingress[].ports[].port` |

---

## Key Concepts

- **NetworkPolicy**: Kubernetes resource for pod-to-pod traffic control
- **podSelector**: Chooses which pods the policy applies to
- **namespaceSelector**: Filters traffic by source namespace
- **ingress**: Defines allowed incoming traffic rules
- **Default Deny**: Once you create a NetworkPolicy, all traffic not explicitly allowed is denied

Congratulations! You've successfully secured your backend service with NetworkPolicy! 🎉
