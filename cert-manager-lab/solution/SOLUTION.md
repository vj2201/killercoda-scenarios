# Solution: cert-manager CRD Lab

## Task 1: Create a list of all cert-manager CRDs

**Goal:** Save all cert-manager CRDs to `/root/resources.yaml`

### Step-by-Step Solution

**1. List all CRDs to see what's available:**
```bash
kubectl get crd
```

**2. Filter for cert-manager CRDs:**
```bash
kubectl get crd | grep cert-manager
```

Expected output shows CRDs like:
- certificates.cert-manager.io
- certificaterequests.cert-manager.io
- challenges.acme.cert-manager.io
- clusterissuers.cert-manager.io
- issuers.cert-manager.io
- orders.acme.cert-manager.io

**3. Get CRD names and retrieve their full YAML:**
```bash
kubectl get crd -o name | grep cert-manager | xargs kubectl get -o yaml > /root/resources.yaml
```

This command:
- `kubectl get crd -o name` - Gets all CRD names in format `customresourcedefinition.apiextensions.k8s.io/name`
- `grep cert-manager` - Filters for cert-manager CRDs only
- `xargs kubectl get -o yaml` - Retrieves full YAML for those CRDs
- `> /root/resources.yaml` - Saves to file

**Alternative approaches:**

**Option 1: Get specific CRDs by name**
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

**Option 2: Using JSON and jq**
```bash
kubectl get crd -o json | \
  jq '.items[] | select(.metadata.name | contains("cert-manager"))' | \
  jq -s '{"apiVersion":"v1","kind":"List","items":.}' > /root/resources.json
```

**Verification:**
```bash
# Check file exists
ls -lh /root/resources.yaml

# View first few lines
head -20 /root/resources.yaml

# Count CRDs saved
grep -c "kind: CustomResourceDefinition" /root/resources.yaml

# Should be 6 cert-manager CRDs
```

## Task 2: Extract documentation for Certificate.spec.subject

**Goal:** Save `subject` field documentation to `/root/subject.yaml`

### Step-by-Step Solution

**1. Explore the Certificate resource:**
```bash
kubectl explain Certificate
```

**2. View spec fields:**
```bash
kubectl explain Certificate.spec
```

This shows all spec fields including `subject`.

**3. View subject field documentation:**
```bash
kubectl explain Certificate.spec.subject
```

**4. Save to file:**
```bash
kubectl explain Certificate.spec.subject > /root/subject.yaml
```

**Alternative approaches:**

**Option 1: With recursive flag (shows all nested fields):**
```bash
kubectl explain Certificate.spec.subject --recursive > /root/subject.yaml
```

**Option 2: Extract from CRD schema (more complex):**
```bash
kubectl get crd certificates.cert-manager.io \
  -o jsonpath='{.spec.versions[0].schema.openAPIV3Schema.properties.spec.properties.subject}' \
  | jq '.' > /root/subject.json
```

**Option 3: Get full spec schema:**
```bash
kubectl explain Certificate.spec.subject --output plaintext-openapiv2 > /root/subject.yaml 2>/dev/null || \
kubectl explain Certificate.spec.subject > /root/subject.yaml
```

**Verification:**
```bash
# Check file exists
ls -lh /root/subject.yaml

# View contents
cat /root/subject.yaml

# Should show documentation for subject field
```

Expected content shows:
```
FIELDS:
  countries    <[]string>
    Countries to be used on the Certificate.

  localities   <[]string>
    Cities to be used on the Certificate.

  organizationalUnits      <[]string>
    Organizational Units to be used on the Certificate.

  organizations        <[]string>
    Organizations to be used on the Certificate.

  postalCodes  <[]string>
    Postal codes to be used on the Certificate.

  provinces    <[]string>
    State/Provinces to be used on the Certificate.

  serialNumber <string>
    Serial number to be used on the Certificate.

  streetAddresses      <[]string>
    Street addresses to be used on the Certificate.
```

## Complete Solution (All-in-One)

```bash
# Task 1: Save all cert-manager CRDs
kubectl get crd -o name | grep cert-manager | xargs kubectl get -o yaml > /root/resources.yaml

# Task 2: Extract subject field documentation
kubectl explain Certificate.spec.subject > /root/subject.yaml

# Verify both files
ls -lh /root/resources.yaml /root/subject.yaml
```

## Understanding the Commands

### kubectl get crd
- Lists Custom Resource Definitions
- `-o name` shows resource type and name
- `-o yaml` outputs full YAML
- Can filter with grep

### kubectl explain
- Shows API documentation from cluster
- Uses OpenAPI schema from CRDs/built-in resources
- Syntax: `resource.field.subfield`
- Outputs human-readable text by default

### xargs
- Takes input from pipe and passes as arguments
- Example: `echo "file1 file2" | xargs cat`
- Useful for batch operations

## Common Mistakes to Avoid

1. **Forgetting the output redirection:**
   ```bash
   # Wrong - prints to screen
   kubectl explain Certificate.spec.subject

   # Right - saves to file
   kubectl explain Certificate.spec.subject > /root/subject.yaml
   ```

2. **Not filtering cert-manager CRDs:**
   ```bash
   # Wrong - gets ALL CRDs (too much)
   kubectl get crd -o yaml > /root/resources.yaml

   # Right - only cert-manager CRDs
   kubectl get crd -o name | grep cert-manager | xargs kubectl get -o yaml > /root/resources.yaml
   ```

3. **Wrong field path:**
   ```bash
   # Wrong - missing 'spec'
   kubectl explain Certificate.subject

   # Right
   kubectl explain Certificate.spec.subject
   ```

## CKA Exam Tips

1. **Use kubectl explain liberally** - it's faster than documentation
2. **Know output formats**: `-o yaml`, `-o json`, `-o name`, `-o wide`
3. **Practice file redirection**: `>` to overwrite, `>>` to append
4. **Combine commands with pipes**: `kubectl get | grep | xargs`
5. **Verify your work**: Always check files were created correctly
6. **Time-saving**: `kubectl explain` is available offline (no internet needed)

## Additional Practice Commands

```bash
# Explore other cert-manager resources
kubectl explain Issuer
kubectl explain ClusterIssuer
kubectl explain CertificateRequest

# Deep dive into fields
kubectl explain Certificate.spec.issuerRef
kubectl explain Certificate.spec.dnsNames
kubectl explain Certificate.spec.secretName

# Recursive exploration
kubectl explain Certificate.spec --recursive

# Compare with built-in resources
kubectl explain Pod.spec.containers
kubectl explain Service.spec.type
kubectl explain Deployment.spec.replicas
```
