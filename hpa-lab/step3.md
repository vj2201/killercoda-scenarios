Add the downscale stabilization window of 30 seconds to the HPA using behavior policies.

The `kubectl autoscale` command doesn't support behavior policies, so you need to either:
1. Edit the existing HPA, OR
2. Delete and recreate with full YAML

**Option 1: Edit existing HPA (recommended)**

```bash
kubectl edit hpa apache-server -n autoscale
```

Add the `behavior` section under `spec`:

```yaml
spec:
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
  maxReplicas: 4
  minReplicas: 1
  # ... rest of spec
```

**Option 2: Delete and recreate with complete YAML**

First, delete the existing HPA:
```bash
kubectl delete hpa apache-server -n autoscale
```

Then create with full spec including behavior:

```bash
kubectl apply -f - <<'YAML'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: apache-server
  namespace: autoscale
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-deployment
  minReplicas: 1
  maxReplicas: 4
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
YAML
```

**Verify the HPA has the behavior policy:**

```bash
kubectl get hpa apache-server -n autoscale -o yaml | grep -A5 behavior
```

You should see:
```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 30
```

**Or use jsonpath:**

```bash
kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}{"\n"}'
```

Expected output: `30`

**Describe the HPA to see all settings:**

`kubectl describe hpa apache-server -n autoscale`

Look for:
- Scale Target Reference: Deployment/apache-deployment
- Min replicas: 1
- Max replicas: 4
- Metrics: cpu / 50%
- Behavior: ScaleDown stabilization window: 30 seconds

**Understanding stabilization windows:**

- **Stabilization window** prevents rapid scaling changes
- **scaleDown**: Controls how quickly HPA removes pods
- **30 seconds**: HPA waits 30 seconds before removing pods after CPU drops
- **Why?**: Prevents flapping when load fluctuates
- **Without it**: Default is 300 seconds (5 minutes)

**Default HPA behavior (without stabilization):**
- Scale up: Immediate when threshold exceeded
- Scale down: Waits 300 seconds (5 minutes)

**With 30 second stabilization:**
- Scale up: Still immediate
- Scale down: Only waits 30 seconds

This makes downscaling much more responsive while still preventing flapping.

**Complete HPA verification:**

```bash
# Check HPA exists
kubectl get hpa apache-server -n autoscale

# Verify all settings
kubectl get hpa apache-server -n autoscale -o yaml

# Watch HPA in action (optional)
kubectl get hpa apache-server -n autoscale --watch
```

Success criteria - all these should be true:
- ✅ HPA named `apache-server` exists in `autoscale` namespace
- ✅ Targets `apache-deployment`
- ✅ CPU target: 50%
- ✅ Min replicas: 1
- ✅ Max replicas: 4
- ✅ Downscale stabilization: 30 seconds

You've successfully completed the HPA configuration!
