Verify the existing deployment and ingress controller are ready.

Check the `echo-deployment` exists in the `echo-sound` namespace:

`kubectl get deploy -n echo-sound`

Verify pods are running:

`kubectl get pods -n echo-sound -o wide`

Check what port the containers are listening on:

`kubectl describe deploy echo-deployment -n echo-sound | grep -A5 "Containers:"`

You should see:
- Deployment: `echo-deployment` with 2 replicas
- Containers named `echo` listening on port `5678`

Verify the ingress controller is installed:

`kubectl get ingressclass`

You should see `nginx` IngressClass available.

Check ingress controller pods are running:

`kubectl get pods -n ingress-nginx`

The `ingress-nginx-controller` pod should be in Running status.

**Current state:**
- ✅ Namespace `echo-sound` exists
- ✅ Deployment `echo-deployment` running (2 pods on port 5678)
- ✅ Nginx ingress controller ready
- ❌ No Service yet (you'll create this in Step 2)
- ❌ No Ingress resource yet (you'll create this in Step 3)
