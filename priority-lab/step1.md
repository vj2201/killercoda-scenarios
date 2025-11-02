Inspect existing PriorityClasses and identify the highest user-defined priority value.

List all PriorityClasses in the cluster:

`kubectl get priorityclass`

You should see both system and user-defined PriorityClasses. System classes typically have names like `system-cluster-critical` or `system-node-critical` and very high values (often in the billions).

View detailed information about all PriorityClasses:

`kubectl get priorityclass -o wide`

To see just the names and values:

`kubectl get priorityclass -o custom-columns=NAME:.metadata.name,VALUE:.value,GLOBAL-DEFAULT:.globalDefault`

**Identify user-defined PriorityClasses:**
- User-defined classes typically have lower values (below 1000000000)
- Look for names like `user-medium-priority`, `user-normal-priority`, etc.
- User-defined classes often start with `user-` prefix
- System classes start with `system-`

**Find the highest value:**
You need to determine which user-defined PriorityClass has the highest value. You can sort by value:

`kubectl get priorityclass --sort-by=.value -o custom-columns=NAME:.metadata.name,VALUE:.value`

Take note of the highest user-defined priority value - you'll need to create a new PriorityClass with a value exactly **one less** than this in the next step.

Verify the current deployment has no priorityClassName set:

`kubectl get deploy busybox-logger -n priority -o jsonpath='{.spec.template.spec.priorityClassName}{"\n"}'`

If empty, the deployment is using the default priority (or no priority if no default exists).
