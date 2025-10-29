CKA Scenarios (Killercoda)

- Sidecar Lab: Add a sidecar container to stream logs from a shared volume.
  - Scenario: https://killercoda.com/vj2201/scenario/sidecar-lab
  - Local setup: `bash sidecar-lab/setup.sh`

- Gateway API Migration Lab: Migrate an existing Ingress to Gateway API while preserving HTTPS and routes.
  - Scenario: https://killercoda.com/vj2201/scenario/gateway-api-lab
  - Local setup: `bash gateway-api-lab/setup.sh`
  - Cleanup: `bash gateway-api-lab/cleanup.sh`

- Resources Lab (Q04): Tune requests/limits evenly across 3 Pods and ensure identical init/main container resources.
  - Scenario: https://killercoda.com/vj2201/scenario/resources-lab-q04
  - Local setup: `bash resources-lab-q04/setup.sh`

Publishing
- Push this repo to GitHub under the `vj2201/CKA-PREP-2025-VJ` namespace (or update links accordingly).
- In Killercoda, scenarios are auto-discovered by folder name; each scenario must contain an `index.json` and step files.
- The public scenario URL follows: `https://killercoda.com/<github-username>/scenario/<foldername>`.
- After pushing, verify the new scenario loads at: https://killercoda.com/vj2201/scenario/resources-lab-q04

