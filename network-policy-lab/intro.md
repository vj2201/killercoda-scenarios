> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Configure Network Policy

## Scenario

Two deployments exist in your cluster:
- **frontend** in namespace `frontend` (labels: app=frontend, tier=web)
- **backend** in namespace `backend` (labels: app=backend, tier=api, port 8080)

Currently, any pod can access the backend service. Your task is to secure the backend by creating a NetworkPolicy that allows traffic ONLY from the frontend namespace.

## Learning Objectives

In this lab, you will:
1. Inspect existing resources to discover labels and ports
2. Create a NetworkPolicy with proper selectors
3. Test and verify the network isolation

## Your Task

Create a least-permissive NetworkPolicy in the `backend` namespace that:
- Allows ingress ONLY from pods in the `frontend` namespace
- Allows traffic ONLY on port 8080
- Denies all other traffic

## Success Criteria

✅ NetworkPolicy named `backend-network-policy` exists in backend namespace
✅ Frontend pods can reach backend:8080
✅ Pods from other namespaces are blocked

Click **"Start"** to begin!
