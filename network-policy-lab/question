> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Configure Network Policy

## Scenario
Two deployments exist:
- `frontend` in namespace `frontend` (labels: app=frontend, tier=web)
- `backend` in namespace `backend` (labels: app=backend, tier=api, port 8080)

## Your Task

1. **Inspect** existing resources to find required NetworkPolicy fields:
   ```bash
   kubectl get pods -n backend --show-labels           # Find pod labels
   kubectl get namespace frontend -o yaml              # Find namespace labels
   kubectl get svc -n backend                          # Find service port
   ```
   Extract: pod labels, namespace labels, container port

2. **Create a NetworkPolicy** named `backend-network-policy` in the `backend` namespace that:
   - Selects backend pods using their labels
   - Allows ingress ONLY from pods in the `frontend` namespace
   - Allows traffic ONLY on port 8080
   - Denies all other traffic

3. **Verify** the NetworkPolicy:
   - Frontend pods can reach backend:8080
   - Other pods are blocked

## Success Criteria
- NetworkPolicy exists in backend namespace
- Frontend pods can reach backend:8080
- All other traffic is blocked

Click **"Next"** for the solution.
