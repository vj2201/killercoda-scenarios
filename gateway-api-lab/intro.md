You will migrate an existing Ingress resource to the Kubernetes Gateway API.

- Current state: an Ingress named `web` provides HTTPS for host `gateway.web.k8s.local` and routes to two Services.
- Goal: create a `Gateway` named `web-gateway` using `GatewayClass` `nginx-class` and an `HTTPRoute` named `web-route` that preserves the TLS host and routing rules.

Note: A `GatewayClass` named `nginx-class` is already installed in the cluster.

