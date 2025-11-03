# Expose Service with Ingress

## Scenario
A deployment `echo-deployment` is running in namespace `echo-sound` on port 5678.

## Your Task
1. Create a NodePort Service named `echo-service` on port 8080 (targeting container port 5678)
2. Create an Ingress named `echo` for `http://example.org/echo`
3. Test connectivity with curl

## Success Criteria
- Service `echo-service` exists with type NodePort
- Ingress `echo` routes traffic to the service
- curl request succeeds with HTTP 200

Click **"Next"** for the solution.
