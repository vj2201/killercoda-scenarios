# Step 1: Export All Cert-Manager CRDs

In this step, you'll explore the cert-manager CustomResourceDefinitions (CRDs) and export them to a file.

## Task: Export CRDs to ~/resources.yaml

### 1. First, list all CRDs in the cluster

```bash
kubectl get crd
```

**Look for cert-manager CRDs** (they typically have names like `certificates.cert-manager.io`, `issuers.cert-manager.io`, etc.)

---

### 2. Filter only cert-manager CRDs

```bash
kubectl get crd | grep cert-manager
```

**You should see CRDs like:**
- `certificates.cert-manager.io`
- `certificaterequests.cert-manager.io`
- `issuers.cert-manager.io`
- `clusterissuers.cert-manager.io`
- And more...

---

### 3. Export ALL cert-manager CRDs to a file

**Hint:** Use `kubectl get` with a label selector or name pattern to export multiple CRDs at once.

**Command to try:**
```bash
kubectl get crd -o yaml | grep -A 10000 "cert-manager.io" > ~/resources.yaml
```

**OR better approach (exports only cert-manager CRDs):**
```bash
kubectl get crd -o yaml -l app.kubernetes.io/instance=cert-manager > ~/resources.yaml
```

**OR export all CRDs that match the pattern:**
```bash
kubectl get crd -o yaml $(kubectl get crd | grep cert-manager | awk '{print $1}') > ~/resources.yaml
```

---

### 4. Verify the export

```bash
cat ~/resources.yaml | head -30
```

**Expected:** You should see `apiVersion: apiextensions.k8s.io/v1` and CRD definitions.

---

### 💡 Hints:

- **CRDs are cluster-scoped** (not namespaced)
- The command should export **all** cert-manager CRDs (typically 6-10 CRDs)
- The output file should be in YAML format
- Use `kubectl get crd` to list all CustomResourceDefinitions
- Filter by name pattern or labels to get only cert-manager CRDs

Click **"Continue"** when you've created `~/resources.yaml`!
