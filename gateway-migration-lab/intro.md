## Question

You have an existing web application deployed in a Kubernetes cluster using an Ingress resource named `web`. You must migrate the existing Ingress configuration to the new Kubernetes Gateway API, maintaining the existing HTTPS access configuration.

**Tasks:**

1. Create a Gateway resource named `web-gateway` with hostname `gateway.web.k8s.local` that maintains the existing TLS and listener configuration from the existing Ingress resource named `web`.

2. Create an HTTPRoute resource named `web-route` with hostname `gateway.web.k8s.local` that maintains the existing routing rules from the current Ingress resource named `web`.

**Note:** A GatewayClass named `nginx-class` is already installed in the cluster.
