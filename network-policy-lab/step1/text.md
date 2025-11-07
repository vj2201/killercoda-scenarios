# Step 1: Discover Required NetworkPolicy Fields

Before creating the NetworkPolicy, you need to inspect the existing resources to find the required labels and ports.

## Task 1: Find Pod Labels (for podSelector)

Check the backend pod labels:

```bash
kubectl get pods -n backend --show-labels
```

You should see output like:
```
NAME                       READY   STATUS    LABELS
backend-xxx-yyy            1/1     Running   app=backend,tier=api,...
```

Or use describe for more details:
```bash
kubectl describe deployment backend -n backend | grep -A 5 "Labels:"
```

**Note down:** `app=backend` and `tier=api` - you'll use these in `podSelector.matchLabels`

---

## Task 2: Find Namespace Labels (for namespaceSelector)

Check the frontend namespace labels:

```bash
kubectl get namespace frontend -o yaml
```

Look for the labels section:
```yaml
metadata:
  labels:
    kubernetes.io/metadata.name: frontend  # ← This is what you need!
  name: frontend
```

**Note down:** `kubernetes.io/metadata.name: frontend` - you'll use this in `namespaceSelector.matchLabels`

---

## Task 3: Find Container Port (for ingress ports)

Check what port the backend service is using:

```bash
kubectl get svc -n backend
```

Or check the deployment directly:
```bash
kubectl get deployment backend -n backend -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}'
```

**Note down:** Port `8080` - you'll use this in `ingress.ports`

---

## Summary

You've discovered:
- **Pod labels:** `app=backend`, `tier=api`
- **Namespace label:** `kubernetes.io/metadata.name: frontend`
- **Port:** `8080`

Click **"Continue"** when you've noted these values!
