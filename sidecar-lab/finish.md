Great job adding a sidecar container!

You successfully:
- Verified the base deployment with a shared volume
- Edited the deployment to add a sidecar container
- Configured the sidecar to mount the same `log-volume` as the main container
- Verified the sidecar can read logs from the shared volume

Key takeaways:
- Sidecar containers run alongside the main container in the same pod
- They share the same network namespace and can share volumes
- Common sidecar patterns: log shipping, service mesh proxies, monitoring agents
- Both containers must mount the same volume to share files

Next steps:
- Explore init containers for setup tasks that run before main containers
- Try multi-container patterns like ambassador or adapter
- Experiment with service mesh sidecars (Istio, Linkerd)
- Practice debugging multi-container pods with `kubectl logs -c <container-name>`
