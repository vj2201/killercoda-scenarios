Verify cert-manager is installed and explore the Custom Resource Definitions (CRDs) it provides.

Check that cert-manager is running:

`kubectl get pods -n cert-manager`

You should see three deployments running:
- cert-manager
- cert-manager-webhook
- cert-manager-cainjector

List all CRDs in the cluster:

`kubectl get crd`

You'll see many CRDs - some from Kubernetes itself, others from cert-manager.

Filter to show only cert-manager CRDs:

`kubectl get crd | grep cert-manager`

You should see CRDs like:
- `certificates.cert-manager.io`
- `certificaterequests.cert-manager.io`
- `issuers.cert-manager.io`
- `clusterissuers.cert-manager.io`
- And others...

View detailed information about a specific CRD:

`kubectl describe crd certificates.cert-manager.io`

Get CRDs with more details:

`kubectl get crd -o wide`

**Understanding CRDs:**
- CRDs extend the Kubernetes API with custom resource types
- They define the schema (fields, validation) for custom resources
- After installing a CRD, you can create instances of that custom resource
- cert-manager CRDs allow you to manage certificates declaratively

In the next step, you'll save the cert-manager CRDs to a file.
