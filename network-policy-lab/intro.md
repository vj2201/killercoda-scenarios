You will enforce cross‑namespace communication using Kubernetes NetworkPolicy.

Scenario:
- Two deployments exist: `frontend` in the `frontend` namespace and `backend` in the `backend` namespace.
- Several candidate NetworkPolicy YAMLs are placed under `/root/network-policies`.

Task:
- Identify the least‑permissive NetworkPolicy that still allows pods in the frontend deployment to communicate with pods in the backend deployment.
- Apply only that policy.

Notes:
- NetworkPolicy is additive: when a pod is selected by any Ingress policy, only traffic explicitly allowed is permitted.
- The backend listens on TCP port 5678. The Service `backend-svc` exposes port 5678 in the `backend` namespace.

You will choose among provided YAMLs and verify connectivity from frontend to backend.

