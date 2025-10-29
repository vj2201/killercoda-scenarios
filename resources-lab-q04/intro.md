You will tune resource requests and limits for a WordPress Deployment.

Goals:
- Scale down the `wordpress` Deployment to 0 replicas.
- Evenly divide node resources across 3 Pods and set fair CPU/memory requests.
- Leave safe overhead (do not request 100% of allocatable).
- Ensure init containers and main containers use exactly the same requests and limits.
- Scale back to 3 replicas and verify.

The setup script creates a base `wordpress` deployment with an init container. You will edit it to add matching resource blocks.

