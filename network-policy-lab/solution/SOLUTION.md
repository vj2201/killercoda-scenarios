Solution: apply the strict allow policy that narrowly permits only frontend pods from the frontend namespace to access backend pods on the backend’s listening port.

Apply:
  kubectl apply -f /root/network-policies/allow-frontend-to-backend-strict.yaml

Reasoning:
- Selects only destination pods `app=backend` in `backend` namespace
- Allows only sources from `frontend` namespace AND pods labeled `app=frontend`
- Limits to TCP/5678 (the backend container port)

Verification:
  kubectl -n frontend exec deploy/frontend -- sh -c "curl -sS http://backend-svc.backend.svc.cluster.local:5678"

