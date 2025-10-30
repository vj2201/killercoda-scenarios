# Ingress to Gateway API Migration - Complete Solution

## Task Summary

Migrate existing Ingress resource `web` to Gateway API by creating:
1. Gateway resource `web-gateway` with TLS configuration
2. HTTPRoute resource `web-route` with routing rules

---

## Step 1: Examine the Existing Ingress

View the current Ingress:

\`\`\`bash
kubectl get ingress web -n web-app -o yaml
\`\`\`

Extract key information:
- Hostname: \`gateway.web.k8s.local\`
- TLS Secret: \`web-tls-secret\`  
- Path: \`/\` → Service \`web-service\` port \`80\`

---

## Step 2: Create the Gateway Resource

The Gateway defines infrastructure (listeners, TLS, ports):

\`\`\`bash
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: web-gateway
  namespace: web-app
spec:
  gatewayClassName: nginx-class
  listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: gateway.web.k8s.local
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: web-tls-secret
EOF
\`\`\`

Verify:

\`\`\`bash
kubectl get gateway -n web-app
kubectl describe gateway web-gateway -n web-app
\`\`\`

---

## Step 3: Create the HTTPRoute Resource

The HTTPRoute defines routing rules:

\`\`\`bash
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: web-route
  namespace: web-app
spec:
  parentRefs:
  - name: web-gateway
  hostnames:
  - gateway.web.k8s.local
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /
    backendRefs:
    - name: web-service
      port: 80
EOF
\`\`\`

Verify:

\`\`\`bash
kubectl get httproute -n web-app
kubectl describe httproute web-route -n web-app
\`\`\`

---

## Verification Checklist

\`\`\`bash
# Check GatewayClass
kubectl get gatewayclass nginx-class

# Check Gateway
kubectl get gateway web-gateway -n web-app

# Check HTTPRoute
kubectl get httproute web-route -n web-app

# Compare with original Ingress
kubectl get ingress web -n web-app
\`\`\`

Success criteria:
- ✅ Gateway \`web-gateway\` exists with HTTPS listener on port 443
- ✅ Gateway uses \`nginx-class\` GatewayClass
- ✅ Gateway hostname is \`gateway.web.k8s.local\`
- ✅ Gateway references TLS secret \`web-tls-secret\`
- ✅ HTTPRoute \`web-route\` references Gateway \`web-gateway\`
- ✅ HTTPRoute hostname is \`gateway.web.k8s.local\`
- ✅ HTTPRoute routes \`/\` to \`web-service\` port 80

---

## Key Mappings: Ingress vs Gateway API

| Ingress Component | Gateway API Resource |
|-------------------|---------------------|
| \`ingressClassName\` | \`gatewayClassName\` |
| \`spec.tls\` | \`Gateway.spec.listeners[].tls\` |
| \`spec.rules[].host\` | \`HTTPRoute.spec.hostnames\` |
| \`spec.rules[].http.paths\` | \`HTTPRoute.spec.rules[].matches\` |
| \`backend.service\` | \`backendRefs[].name\` |

---

## Common Mistakes

1. **Wrong namespace** - Gateway, HTTPRoute, and Service must be in same namespace
2. **Typo**: \`certificateRefs\` (plural) not \`certificateRef\`
3. **Missing parentRefs** - HTTPRoute must reference Gateway
4. **Wrong path type** - Use \`PathPrefix\` not \`Prefix\`

---

## Useful Commands

\`\`\`bash
# Explain syntax
kubectl explain gateway.spec.listeners
kubectl explain httproute.spec.rules

# List resources
kubectl get gateway,httproute -A

# View details
kubectl describe gateway web-gateway -n web-app
kubectl describe httproute web-route -n web-app
\`\`\`

---

**Congratulations!** You've successfully migrated from Ingress to Gateway API.
