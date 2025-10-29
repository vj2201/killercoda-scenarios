Finally, scale back to 3 replicas and verify that Pods are scheduled and using the configured requests/limits.

Scale and wait for rollout:

`kubectl scale deploy wordpress --replicas=3`

`kubectl rollout status deploy/wordpress --timeout=180s`

Verify Pods and resources:

- `kubectl get pods -l app=wordpress -o wide`
- `kubectl describe pod -l app=wordpress | grep -A6 "Limits:\\|Requests:"`

Optional (if metrics-server is available):

- `kubectl top pods -l app=wordpress`

Success criteria:
- Exactly 3 Pods are Running.
- Init and main containers show identical resource requests/limits.
- Total requested CPU/memory leaves safe overhead relative to node allocatable.

