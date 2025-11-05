> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Configure Network Policy

## Scenario
Two deployments exist:
- `frontend` in namespace `frontend` (labels: app=frontend, tier=web)
- `backend` in namespace `backend` (labels: app=backend, tier=api, port 8080)

## Your Task
Create a least-permissive NetworkPolicy in the `backend` namespace that:
1. Allows ingress ONLY from pods in the `frontend` namespace
2. Allows traffic ONLY on port 8080
3. Denies all other traffic

## Success Criteria
- NetworkPolicy exists in backend namespace
- Frontend pods can reach backend:8080
- All other traffic is blocked

Click **"Next"** for the solution.
