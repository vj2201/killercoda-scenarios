# Solution: PriorityClass Lab

## Step 1: Inspect existing PriorityClasses

```bash
# List all PriorityClasses
kubectl get priorityclass

# View with values
kubectl get priorityclass -o custom-columns=NAME:.metadata.name,VALUE:.value,GLOBAL-DEFAULT:.globalDefault

# Sort by value to find highest
kubectl get priorityclass --sort-by=.value -o custom-columns=NAME:.metadata.name,VALUE:.value
```

Expected output shows:
- System classes: `system-cluster-critical` (2000001000), `system-node-critical` (2000000000)
- User-defined classes: `medium-priority` (1000), `normal-priority` (500)

**Highest user-defined value: 1000** (from `medium-priority`)

## Step 2: Create high-priority PriorityClass

The new class should have value = 1000 - 1 = **999**

```bash
kubectl apply -f - <<'YAML'
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 999
globalDefault: false
description: "High priority for critical user workloads"
YAML
```

Verify:
```bash
kubectl get priorityclass high-priority
kubectl describe pc high-priority
```

## Step 3: Patch the deployment

**Option 1: Using kubectl patch**
```bash
kubectl patch deployment busybox-logger -n priority -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'
```

**Option 2: Using kubectl set**
```bash
# This doesn't work for priorityClassName, use patch instead
```

**Option 3: Using kubectl edit**
```bash
kubectl edit deployment busybox-logger -n priority
```

Add under `spec.template.spec`:
```yaml
priorityClassName: high-priority
```

## Verification

```bash
# Check rollout status
kubectl rollout status deployment/busybox-logger -n priority

# Verify pods have the priority class
kubectl get pods -n priority -o custom-columns=NAME:.metadata.name,PRIORITY-CLASS:.spec.priorityClassName

# Detailed verification
kubectl describe pod -n priority -l app=busybox-logger | grep -i priority
```

Expected output:
```
Priority Class Name:  high-priority
Priority:             999
```

## Complete Solution Commands

```bash
# 1. Inspect (find highest user-defined is 1000)
kubectl get priorityclass --sort-by=.value

# 2. Create PriorityClass with value 999
kubectl apply -f solution/high-priority.solution.yaml

# 3. Patch deployment
kubectl patch deployment busybox-logger -n priority -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'

# 4. Verify
kubectl get pods -n priority -o custom-columns=NAME:.metadata.name,PRIORITY:.spec.priorityClassName
```
