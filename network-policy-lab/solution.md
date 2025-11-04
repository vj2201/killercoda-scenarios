# Solution

## Create NetworkPolicy

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

✅ **Done!** Only frontend namespace can reach backend on port 8080.
