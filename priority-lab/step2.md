Create a new PriorityClass named `high-priority` with a value exactly one less than the highest user-defined priority class you identified.

Based on your inspection in Step 1, if the highest user-defined PriorityClass has a value of `1000`, your new class should have a value of `999`.

Create the PriorityClass using kubectl:

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

**Note:** Adjust the `value` field based on what you found in Step 1. The value should be exactly **one less** than the highest existing user-defined priority class.

Verify the PriorityClass was created:

`kubectl get priorityclass high-priority`

View its details:

`kubectl describe priorityclass high-priority`

You should see:
- Name: `high-priority`
- Value: (one less than the highest user-defined priority you found)
- Global Default: `false`

**Understanding the fields:**
- `value`: The priority value (higher numbers = higher priority)
- `globalDefault`: If true, this priority is used for pods without a priorityClassName
- `description`: Human-readable description of when to use this class
