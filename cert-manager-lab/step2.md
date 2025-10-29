Create a list of all cert-manager CRDs and save it to `/root/resources.yaml`.

Get all CRDs and filter for cert-manager:

`kubectl get crd | grep cert-manager`

This shows names but not in a format suitable for saving.

**Option 1: Using grep and output to YAML**

Get all CRDs in YAML format and filter:

```bash
kubectl get crd -o yaml | grep -A 100 "cert-manager.io" > /root/resources.yaml
```

**Option 2: Using labels (if available)**

Check if cert-manager CRDs have a label:

`kubectl get crd -o yaml | grep -A5 "labels:"`

**Option 3: Get specific cert-manager CRDs**

```bash
kubectl get crd \
  certificates.cert-manager.io \
  certificaterequests.cert-manager.io \
  challenges.acme.cert-manager.io \
  clusterissuers.cert-manager.io \
  issuers.cert-manager.io \
  orders.acme.cert-manager.io \
  -o yaml > /root/resources.yaml
```

**Option 4: Using JSONPath to filter (most precise)**

```bash
kubectl get crd -o json | \
  jq '.items[] | select(.metadata.name | contains("cert-manager"))' | \
  kubectl apply --dry-run=client -o yaml -f - > /root/resources.yaml
```

Or simpler with grep on names:

```bash
kubectl get crd -o name | grep cert-manager | \
  xargs kubectl get -o yaml > /root/resources.yaml
```

**Recommended approach for the exam:**

```bash
kubectl get crd -o name | grep cert-manager | xargs kubectl get -o yaml > /root/resources.yaml
```

This:
1. Gets all CRD names (`crd/certificates.cert-manager.io`, etc.)
2. Filters for cert-manager CRDs
3. Gets full YAML for those CRDs
4. Saves to file

Verify the file was created:

`ls -lh /root/resources.yaml`

Check the contents (first 20 lines):

`head -20 /root/resources.yaml`

You should see YAML with `apiVersion: apiextensions.k8s.io/v1` and CRD definitions.

Count how many cert-manager CRDs were saved:

`grep -c "kind: CustomResourceDefinition" /root/resources.yaml`

In the next step, you'll extract API documentation for a specific field.
