Wrap‑up

- The least‑permissive working policy narrowly targets:
  - Destination: only pods labeled `app=backend` in the `backend` namespace
  - Source: only pods labeled `app=frontend` from the `frontend` namespace
  - Ports: only TCP/5678 (the backend’s listening port)

- Example solution apply:
  kubectl apply -f /root/network-policies/allow-frontend-to-backend-strict.yaml

Verification:
- From a frontend pod, a request to the backend service should succeed:
  kubectl -n frontend exec deploy/frontend -- sh -c "curl -sS http://backend-svc.backend.svc.cluster.local:5678"

- Traffic from other namespaces/pods should not be allowed to backend pods, since only the specified source and port are permitted.

