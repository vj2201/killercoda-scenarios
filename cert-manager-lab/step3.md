Extract the documentation for the `subject` specification field of the Certificate Custom Resource and save it to `/root/subject.yaml`.

First, understand the Certificate resource structure:

`kubectl explain Certificate`

This shows the top-level structure of the Certificate resource.

View the spec field:

`kubectl explain Certificate.spec`

This shows all fields under `spec`, including `subject`.

View the subject field documentation:

`kubectl explain Certificate.spec.subject`

This displays the documentation for the `subject` field.

**Now save it to a file:**

```bash
kubectl explain Certificate.spec.subject > /root/subject.yaml
```

**Alternative formats:**

While the task says "any output format", `kubectl explain` outputs in a human-readable text format by default. You can also use:

**Option 1: Plain text (default)**
```bash
kubectl explain Certificate.spec.subject > /root/subject.yaml
```

**Option 2: Using --output (newer kubectl versions)**
```bash
kubectl explain Certificate.spec.subject --output plaintext-openapiv2 > /root/subject.yaml
```

**Option 3: Get the schema from the CRD directly**
```bash
kubectl get crd certificates.cert-manager.io -o jsonpath='{.spec.versions[0].schema.openAPIV3Schema.properties.spec.properties.subject}' | jq '.' > /root/subject.yaml
```

**Recommended for the exam (simplest):**

```bash
kubectl explain Certificate.spec.subject > /root/subject.yaml
```

Verify the file was created:

`ls -lh /root/subject.yaml`

View the contents:

`cat /root/subject.yaml`

You should see documentation describing:
- What the `subject` field is for
- Its type (object)
- Sub-fields like `countries`, `localities`, `organizations`, etc.
- Descriptions of each sub-field

**Understanding kubectl explain:**
- Shows API documentation directly from the cluster
- Uses OpenAPI schema embedded in CRDs
- Format: `kubectl explain <TYPE>.<FIELD>.<SUBFIELD>`
- Examples:
  - `kubectl explain Pod.spec.containers`
  - `kubectl explain Service.spec.type`
  - `kubectl explain Deployment.spec.replicas`

**Exploring more:**

See all subject sub-fields:

`kubectl explain Certificate.spec.subject --recursive`

Get specific sub-field docs:

`kubectl explain Certificate.spec.subject.organizations`

Verify both task files exist:

```bash
ls -lh /root/resources.yaml /root/subject.yaml
```

You've successfully completed both tasks!
