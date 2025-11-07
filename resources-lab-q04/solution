# Solution

## Step 1: Scale Down Deployment
```bash
kubectl get deployment wordpress
kubectl scale deployment wordpress --replicas=0
kubectl get pods
```

## Step 2: Edit Deployment and Add Resources
```bash
kubectl edit deployment wordpress
# Find initContainers section and add:
# resources:
#   requests:
#     cpu: 300m
#     memory: 256Mi
#   limits:
#     cpu: 300m
#     memory: 256Mi
#
# Find containers section and add same resources block

# Or use kubectl patch:
kubectl patch deployment wordpress --type='json' -p='[
  {"op": "add", "path": "/spec/template/spec/initContainers/0/resources",
   "value": {"requests": {"cpu": "300m", "memory": "256Mi"}, "limits": {"cpu": "300m", "memory": "256Mi"}}},
  {"op": "add", "path": "/spec/template/spec/containers/0/resources",
   "value": {"requests": {"cpu": "300m", "memory": "256Mi"}, "limits": {"cpu": "300m", "memory": "256Mi"}}}
]'
```

## Step 3: Scale Back and Verify
```bash
kubectl scale deployment wordpress --replicas=3
kubectl get pods -o wide
kubectl describe deployment wordpress
```

## Explanation
Resource requests ensure pods are scheduled on nodes with sufficient capacity, while limits prevent containers from consuming excessive resources. Both init and main containers need identical resources for consistent scheduling behavior.

✅ **Done!** WordPress deployment scaled with fair resource allocation.
