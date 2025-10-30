Congratulations! You've successfully migrated from Ingress to Gateway API.

**What you learned:**

1. **Gateway API Basics** - Understanding the new routing standard
2. **Resource Mapping** - Converting Ingress to Gateway + HTTPRoute
3. **TLS Configuration** - Migrating HTTPS listeners
4. **Routing Rules** - Translating Ingress paths to HTTPRoute matches

**Key Concepts:**

- **GatewayClass**: Defines the gateway controller implementation
- **Gateway**: Infrastructure configuration (listeners, TLS, ports)
- **HTTPRoute**: Application routing rules (paths, backends)
- **Separation of Concerns**: Infrastructure (Gateway) vs routing (HTTPRoute)

**Migration Mapping:**

```
Ingress                    → Gateway API
├─ ingressClassName        → gatewayClassName
├─ spec.tls                → Gateway.spec.listeners[].tls
├─ spec.rules[].host       → HTTPRoute.spec.hostnames[]
└─ spec.rules[].http.paths → HTTPRoute.spec.rules[].matches
```

**Key Commands:**

- `kubectl get gatewayclass` - List available gateway controllers
- `kubectl get gateway -n <namespace>` - List gateways
- `kubectl get httproute -n <namespace>` - List HTTP routes
- `kubectl describe gateway <name> -n <namespace>` - View gateway details

**CKA Exam Tips:**

- Gateway and HTTPRoute must be in the same namespace as the Service
- Use `kubectl explain` for Gateway API syntax
- Remember: `certificateRefs` (plural) not `certificateRef`
- HTTPRoute `parentRefs` links to the Gateway
- Gateway API is still evolving - check version compatibility

Great job!
