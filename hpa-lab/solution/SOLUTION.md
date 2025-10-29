# Solution: HorizontalPodAutoscaler Lab

## Complete Solution

Create a HorizontalPodAutoscaler named `apache-server` with:
- Target: apache-deployment
- CPU: 50%
- Min/Max: 1-4 pods
- Downscale stabilization: 30 seconds

### Single Command (Complete Solution)

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

Or use the solution file:
```bash
kubectl apply -f solution/apache-server-hpa.solution.yaml
```

### Two-Step Approach (Imperative + Edit)

**Step 1: Create basic HPA**
```bash
kubectl autoscale deployment apache-deployment \
  --name=apache-server \
  --cpu-percent=50 \
  --min=1 \
  --max=4 \
  -n autoscale
```

**Step 2: Add behavior policy**
```bash
kubectl edit hpa apache-server -n autoscale
```

Add under `spec`:
```yaml
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
```

## Verification

### Check HPA exists
```bash
kubectl get hpa -n autoscale
```

Expected output:
```
NAME            REFERENCE                     TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
apache-server   Deployment/apache-deployment  0%/50%    1         4         1          30s
```

### Verify all settings
```bash
kubectl describe hpa apache-server -n autoscale
```

Should show:
- Scale Target Reference: Deployment/apache-deployment
- Metrics: cpu / 50%
- Min replicas: 1
- Max replicas: 4
- Behavior: ScaleDown stabilizationWindowSeconds: 30

### Check specific fields

**Verify stabilization window:**
```bash
kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}{"\n"}'
```
Expected: `30`

**Verify CPU target:**
```bash
kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}{"\n"}'
```
Expected: `50`

**Verify min/max:**
```bash
kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.minReplicas} {.spec.maxReplicas}{"\n"}'
```
Expected: `1 4`

### Full YAML verification
```bash
kubectl get hpa apache-server -n autoscale -o yaml
```

## Step-by-Step Explanation

### 1. Verify Prerequisites

**Check deployment:**
```bash
kubectl get deploy apache-deployment -n autoscale
```

**Check pods have resource requests:**
```bash
kubectl describe deploy apache-deployment -n autoscale | grep -A5 Requests
```

Must see CPU requests (e.g., 100m) for HPA to work.

**Check metrics-server:**
```bash
kubectl get deployment metrics-server -n kube-system
kubectl top pods -n autoscale
```

### 2. Create HPA

The HPA needs autoscaling/v2 API for behavior policies.

**Key spec fields:**

- `scaleTargetRef`: Which deployment to scale
  ```yaml
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: apache-deployment
  ```

- `minReplicas` / `maxReplicas`: Scaling boundaries
  ```yaml
  minReplicas: 1
  maxReplicas: 4
  ```

- `metrics`: What to measure
  ```yaml
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
  ```

- `behavior`: Scaling behavior policies
  ```yaml
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 30
  ```

### 3. Understanding Behavior Policies

**Without stabilization window:**
```
CPU drops below 50% → HPA immediately wants to scale down → Waits 5 minutes (default) → Removes pod
```

**With 30 second stabilization:**
```
CPU drops below 50% → HPA immediately wants to scale down → Waits only 30 seconds → Removes pod
```

**Why it matters:**
- Prevents flapping when load is variable
- Balances responsiveness vs stability
- Default 5 minutes is too slow for many workloads
- 30 seconds is more responsive

## Alternative Approaches

### Approach 1: Using autoscaling/v1 (basic, no behavior)

```bash
kubectl apply -f - <<'YAML'
apiVersion: autoscaling/v1
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
  targetCPUUtilizationPercentage: 50
YAML
```

**Problem:** autoscaling/v1 doesn't support behavior policies!

### Approach 2: Using v2beta2 (older)

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
# ... same as v2 ...
```

Works but v2 is preferred (stable since Kubernetes 1.23).

### Approach 3: Patch existing HPA

```bash
kubectl patch hpa apache-server -n autoscale --type=merge -p '
{
  "spec": {
    "behavior": {
      "scaleDown": {
        "stabilizationWindowSeconds": 30
      }
    }
  }
}'
```

## Common Mistakes

### 1. Wrong API version
```yaml
apiVersion: autoscaling/v1  # ❌ No behavior support
```

Should be:
```yaml
apiVersion: autoscaling/v2  # ✅ Has behavior support
```

### 2. Missing resource requests
```yaml
# Deployment without requests
containers:
- name: apache
  image: httpd:2.4
  # ❌ No resources!
```

HPA will show: "unable to compute replica count: missing request for cpu"

### 3. Wrong target reference
```yaml
scaleTargetRef:
  name: apache-deploy  # ❌ Wrong name
```

Should match actual deployment name: `apache-deployment`

### 4. Stabilization in wrong place
```yaml
behavior:
  scaleUp:  # ❌ Wrong! Question asks for scaleDown
    stabilizationWindowSeconds: 30
```

Should be:
```yaml
behavior:
  scaleDown:  # ✅ Correct
    stabilizationWindowSeconds: 30
```

## Testing the HPA

### Generate load (optional)

**Create a service first:**
```bash
kubectl expose deployment apache-deployment \
  --name=apache-service \
  --port=80 \
  --target-port=80 \
  -n autoscale
```

**Generate load:**
```bash
kubectl run load-generator \
  --image=busybox:1.28 \
  --restart=Never \
  -n autoscale \
  -- /bin/sh -c "while true; do wget -q -O- http://apache-service; done"
```

**Watch HPA scale:**
```bash
kubectl get hpa apache-server -n autoscale --watch
```

You'll see:
1. CPU increase to >50%
2. REPLICAS increase (1 → 2 → 3 → 4)
3. Delete load-generator: `kubectl delete pod load-generator -n autoscale`
4. CPU decrease to <50%
5. After 30 seconds, REPLICAS decrease

### Check scaling events
```bash
kubectl get events -n autoscale --field-selector involvedObject.name=apache-server
```

## CKA Exam Tips

1. **Know both approaches:**
   - `kubectl autoscale` for basic HPA
   - YAML for behavior policies

2. **API version matters:**
   - v1: Basic CPU only
   - v2: Multiple metrics + behavior

3. **Behavior = v2 only:**
   - Can't use `kubectl autoscale` for behavior
   - Must use YAML or edit

4. **Verify your work:**
   ```bash
   kubectl describe hpa
   kubectl get hpa -o yaml
   ```

5. **Common exam variations:**
   - Different stabilization windows (60s, 120s, etc.)
   - Multiple metrics (CPU + memory)
   - Different target percentages

6. **Quick reference:**
   ```bash
   # Create basic
   kubectl autoscale deployment NAME --cpu-percent=50 --min=1 --max=4

   # Add behavior
   kubectl edit hpa NAME

   # Verify
   kubectl describe hpa NAME
   ```

## Additional Practice

### Multiple metrics (CPU + Memory)
```yaml
metrics:
- type: Resource
  resource:
    name: cpu
    target:
      type: Utilization
      averageUtilization: 50
- type: Resource
  resource:
    name: memory
    target:
      type: Utilization
      averageUtilization: 70
```

### Advanced behavior
```yaml
behavior:
  scaleDown:
    stabilizationWindowSeconds: 30
    policies:
    - type: Pods
      value: 1
      periodSeconds: 60
    - type: Percent
      value: 10
      periodSeconds: 60
    selectPolicy: Min
  scaleUp:
    stabilizationWindowSeconds: 0
    policies:
    - type: Pods
      value: 2
      periodSeconds: 60
    - type: Percent
      value: 50
      periodSeconds: 60
    selectPolicy: Max
```

### Different metric targets
```yaml
target:
  type: AverageValue
  averageValue: "100m"  # Target 100 millicores per pod
```

Or:
```yaml
target:
  type: Value
  value: "500m"  # Total 500 millicores across all pods
```

## Success Checklist

- [x] HPA named `apache-server` exists
- [x] In namespace `autoscale`
- [x] Targets `apache-deployment`
- [x] CPU target: 50%
- [x] Min replicas: 1
- [x] Max replicas: 4
- [x] Downscale stabilization: 30 seconds
- [x] Using autoscaling/v2 API
- [x] Behavior policy configured

Run this to verify everything:
```bash
echo "Name: $(kubectl get hpa apache-server -n autoscale -o jsonpath='{.metadata.name}')"
echo "Target: $(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.scaleTargetRef.name}')"
echo "CPU Target: $(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}')%"
echo "Min: $(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.minReplicas}')"
echo "Max: $(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.maxReplicas}')"
echo "Stabilization: $(kubectl get hpa apache-server -n autoscale -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}')s"
```

Expected output:
```
Name: apache-server
Target: apache-deployment
CPU Target: 50%
Min: 1
Max: 4
Stabilization: 30s
```

Perfect! You've completed the HPA lab successfully.
