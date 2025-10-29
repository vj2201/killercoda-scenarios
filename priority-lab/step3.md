Patch the existing `busybox-logger` deployment to use the newly created `high-priority` PriorityClass.

Patch the deployment using kubectl:

`kubectl patch deployment busybox-logger -n priority -p '{"spec":{"template":{"spec":{"priorityClassName":"high-priority"}}}}'`

Alternatively, you can edit the deployment directly:

`kubectl edit deployment busybox-logger -n priority`

Add the `priorityClassName` field under `spec.template.spec`:

```yaml
spec:
  template:
    spec:
      priorityClassName: high-priority
      containers:
      - name: logger
        ...
```

Wait for the rollout to complete:

`kubectl rollout status deployment/busybox-logger -n priority`

Verify the pods are using the new priority class:

`kubectl get pods -n priority -o custom-columns=NAME:.metadata.name,PRIORITY-CLASS:.spec.priorityClassName`

You should see `high-priority` listed for all pods.

Verify in detail:

`kubectl describe pod -n priority -l app=busybox-logger | grep -i priority`

You should see:
- Priority Class Name: `high-priority`
- Priority: 999 (or whatever value you set)

**Success criteria:**
- The `high-priority` PriorityClass exists with the correct value
- The `busybox-logger` deployment has `priorityClassName: high-priority` in its pod template
- All running pods show the priority class and priority value

**Why this matters:**
When cluster resources are constrained, pods with higher priority values are:
1. Scheduled before lower-priority pods
2. Less likely to be preempted/evicted
3. Preferred during resource allocation decisions
