You will configure a deployment to expose ports and create a NodePort Service.

**Scenario:**
A deployment named `nodeport-deployment` exists in the `relative` namespace but isn't properly configured for external access.

**Tasks:**
1. Configure the deployment so it can be exposed on port 80 (add containerPort with name=http, protocol=TCP)
2. Create a new Service named `nodeport-service` exposing container port 80, protocol TCP, NodePort 30080
3. Configure the Service to expose individual pods using NodePort

**Key Concepts:**
- **containerPort** - Declares which port the container listens on
- **NodePort Service** - Exposes pods on a static port on each node
- **Port mapping** - Service port → container port
- **Selectors** - How Services find pods to route traffic to
- **NodePort range** - 30000-32767 (default)

The setup has already created the `nodeport-deployment` with 2 replicas running nginx, but without containerPort configured.
