# Gateway API Configuration

## Scenario
Migrate traffic routing from traditional Ingress to the Kubernetes Gateway API for better flexibility and control.

## Your Task
1. Create a Gateway (web-gateway, HTTPS, port 443, host gateway.web.k8s.local, TLS secret web-tls)
2. Create an HTTPRoute (web-route) that routes / to web-svc:80 and /api to api-svc:8080
3. Verify both routes are accessible through the gateway

## Success Criteria
- Gateway web-gateway has Programmed status
- HTTPRoute web-route has Accepted status
- Traffic routes correctly to both backends

Click **"Next"** for the solution.
