# Configure HorizontalPodAutoscaler

## Scenario
A deployment `apache-deployment` exists in namespace `autoscale` with CPU resource requests configured. The metrics-server is installed.

## Your Task
1. Create an HPA named `apache-server` targeting 50% CPU utilization
2. Configure min replicas: 1, max replicas: 4
3. Set downscale stabilization window to 30 seconds

## Success Criteria
- HPA exists targeting apache-deployment
- CPU target is 50%
- Min/max replicas are 1/4
- Downscale stabilization window is 30 seconds

Click **"Next"** for the solution.
