You will expose a deployment using a Service and create an Ingress resource to route HTTP traffic.

**Scenario:**
An existing deployment named `echo-deployment` is running in the `echo-sound` namespace. You need to expose it externally using Kubernetes Ingress.

**Tasks:**
1. Expose the existing deployment with a Service called `echo-service` using Service Port 8080, type NodePort
2. Create a new Ingress resource named `echo` in the `echo-sound` namespace for `http://example.org/echo`
3. Verify the Service availability using curl commands

**Key Concepts:**
- Services provide stable endpoints for pods
- NodePort services expose pods on a specific port on all nodes
- Ingress resources provide HTTP/HTTPS routing to services
- Ingress controllers (like nginx) implement the Ingress specification
- Host-based and path-based routing can be configured

**Note:** The setup script has already:
- Created the `echo-sound` namespace
- Deployed `echo-deployment` (2 replicas running on port 5678)
- Installed nginx ingress controller

You will create the Service and Ingress to expose this deployment.
