# Solution

## Step 1: Add Taint to node01

```bash
kubectl taint nodes node01 PERMISSION=granted:NoSchedule
```

**Verify:**
```bash
kubectl describe node node01 | grep Taints
```

Expected: `Taints: PERMISSION=granted:NoSchedule`

## Step 2: Create Pod with Matching Toleration

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx
  tolerations:
  - key: "PERMISSION"
    operator: "Equal"
    value: "granted"
    effect: "NoSchedule"
EOF
```

**Verify:**
```bash
kubectl get pod nginx -o wide
```

Expected: Pod should be running on node01.

## Optional: Test the Taint

Create a pod without toleration to verify it cannot be scheduled on node01:

```bash
kubectl run test-pod --image=nginx
kubectl get pod test-pod -o wide
```

The test-pod will be scheduled on the control-plane node (or remain pending if only node01 is available).

```bash
# Cleanup
kubectl delete pod test-pod
```

## Explanation

**Taint:** Prevents pods from being scheduled on node01 unless they have a matching toleration.
- Format: `key=value:effect`
- Effects: NoSchedule, PreferNoSchedule, NoExecute

**Toleration:** Allows the nginx pod to "tolerate" the taint and be scheduled on node01.
- All three components (key, value, effect) must match exactly
- `operator: "Equal"` means value must match; `operator: "Exists"` ignores value

✅ **Done!** Only pods with the PERMISSION=granted toleration can run on node01.
