Verify the deployment exists and metrics-server is running.

Check the `apache-deployment` in the autoscale namespace:

`kubectl get deploy -n autoscale`

Verify pods are running:

`kubectl get pods -n autoscale`

Check the deployment has resource requests (required for CPU-based HPA):

`kubectl describe deploy apache-deployment -n autoscale | grep -A5 "Limits\\|Requests"`

You should see:
- CPU request: 100m
- Memory request: 128Mi
- CPU limit: 200m
- Memory limit: 256Mi

**Verify metrics-server is running:**

`kubectl get deployment metrics-server -n kube-system`

`kubectl get pods -n kube-system | grep metrics-server`

**Check if metrics are available:**

`kubectl top nodes`

`kubectl top pods -n autoscale`

**Note:** Metrics may take 30-60 seconds after cluster start to become available. If you see "error: Metrics API not available", wait a moment and try again.

**Understanding resource requests for HPA:**
- HPA requires resource requests to calculate CPU percentage
- Formula: `Current CPU / Requested CPU * 100 = Percentage`
- Example: Pod using 50m CPU with 100m request = 50% utilization
- Without requests, HPA cannot calculate percentage-based metrics

**Current state:**
- ✅ Namespace `autoscale` exists
- ✅ Deployment `apache-deployment` running (1 replica)
- ✅ Pods have CPU requests (100m)
- ✅ metrics-server installed
- ❌ No HPA yet (you'll create this in the next steps)

In the next step, you'll create the HPA.
