# Resource Requests and Limits

## Scenario
Configure fair resource allocation for a WordPress deployment with both init containers and main containers.

## Your Task
1. Scale WordPress deployment to 0 replicas
2. Edit deployment to add resources (requests/limits: cpu 300m, memory 256Mi) to initContainers and containers
3. Scale back to 3 replicas and verify all pods are running

## Success Criteria
- WordPress deployment has 3 running replicas
- Both initContainers and containers have identical resource specs
- Pods are evenly distributed across available nodes

Click **"Next"** for the solution.
