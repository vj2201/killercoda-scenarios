# Solution

## Step 1: Identify Existing PriorityClasses

```bash
kubectl get priorityclass
```

You'll see `user-medium-priority` (1000) and `user-normal-priority` (500). The highest user-defined value is 1000.

---

## Step 2: Create high-priority PriorityClass

```bash
kubectl apply -f - <<EOF
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
value: 999
globalDefault: false
description: "High priority for critical user workloads"
EOF
```

**Verify:**
```bash
kubectl get priorityclass high-priority
```

---

## Step 3: Update Deployment

```bash
kubectl patch deployment busybox-logger -n priority \
  -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'
```

**Verify:**
```bash
kubectl get pods -n priority -o custom-columns=NAME:.metadata.name,PRIORITY:.spec.priorityClassName
```

Expected output:
```
NAME                              PRIORITY
busybox-logger-xxxx-xxxx          high-priority
```

---

## Explanation

**PriorityClass** controls pod scheduling order when resources are limited. Higher values = higher priority. The value 999 is one less than the highest existing user-defined priority (1000).

**Why patch?** Updating the deployment spec causes a rolling restart, applying the new priorityClassName to all pods.

✅ **Done!** Your deployment now runs with elevated priority.
