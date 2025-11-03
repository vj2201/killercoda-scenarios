# Solution

## Step 1: Create Basic HPA

```bash
kubectl autoscale deployment apache-deployment \
  --name=apache-server \
  --cpu-percent=50 \
  --min=1 \
  --max=4 \
  -n autoscale
```

**Verify:**
```bash
kubectl get hpa apache-server -n autoscale
```

## Step 2: Add Behavior Policy (Downscale Stabilization)

```bash
kubectl edit hpa apache-server -n autoscale
```

Add this under `spec`:
```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 30
```

Save and exit.

## Step 3: Verify Configuration

```bash
kubectl get hpa apache-server -n autoscale -o yaml
```

Check that you see:
- `targetCPUUtilizationPercentage: 50`
- `minReplicas: 1`
- `maxReplicas: 4`
- `behavior.scaleDown.stabilizationWindowSeconds: 30`

**Verify stabilization window:**
```bash
kubectl get hpa apache-server -n autoscale \
  -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}{"\n"}'
```

Expected output: `30`

## Explanation

**HPA** automatically scales pods based on CPU/memory metrics. The 50% target means: if average CPU > 50%, scale up; if < 50%, scale down.

**Stabilization window** prevents flapping by delaying scale-down decisions for 30 seconds after a scale-down recommendation.

✅ **Done!** Your deployment will auto-scale between 1-4 replicas based on CPU load.
