Goal: Allow frontend pods to reach backend pods with the least‑permissive NetworkPolicy.

What’s provided:
- Namespaces: `frontend`, `backend`
- Deployments: `frontend` (curl image), `backend` (http-echo on 5678)
- Service: `backend/backend-svc` on port 5678
- Candidate policies: `/root/network-policies/*.yaml`

Tasks:
- Inspect the candidate policies:
  ls -1 /root/network-policies

- Decide which YAML is the least permissive that still allows frontend → backend access.

- Apply your chosen policy (example):
  kubectl apply -f /root/network-policies/allow-frontend-to-backend-strict.yaml

- Verify that traffic from frontend to backend succeeds:
  kubectl -n frontend exec deploy/frontend -- sh -c "curl -sS http://backend-svc.backend.svc.cluster.local:5678"

Tip:
- The strictest valid policy will typically restrict:
  - Destination pods (select only `app=backend`),
  - Source to the specific namespace (`frontend`) and source pods (`app=frontend`),
  - Destination port (5678/TCP).

