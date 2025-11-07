# Step 2: Create the NetworkPolicy

Now that you've discovered the required values, create the NetworkPolicy using the information from Step 1.

## Create NetworkPolicy

Use the values you discovered:
- **podSelector:** `app=backend`, `tier=api`
- **namespaceSelector:** `kubernetes.io/metadata.name: frontend`
- **Port:** `8080`

Create the NetworkPolicy:

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

---

## Verify the NetworkPolicy

Check that it was created:

```bash
kubectl get networkpolicy -n backend
```

Describe it to see the rules:

```bash
kubectl describe networkpolicy backend-network-policy -n backend
```

---

## Understanding the NetworkPolicy

This NetworkPolicy:
- **`podSelector`**: Targets backend pods with matching labels
- **`namespaceSelector`**: Allows traffic only from frontend namespace
- **`ports`**: Restricts traffic to port 8080 only
- **`policyTypes: [Ingress]`**: Creates a default deny for all ingress traffic (except what's explicitly allowed)

Click **"Continue"** to test the network isolation!
