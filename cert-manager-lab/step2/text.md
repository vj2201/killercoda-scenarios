# Step 2: Extract Certificate.spec.subject Documentation

In this step, you'll use `kubectl explain` to extract API documentation for a specific field.

## Task: Extract subject field documentation to ~/subject.yaml

### 1. Understand kubectl explain

`kubectl explain` shows documentation for Kubernetes resources and their fields.

**Try it:**
```bash
kubectl explain certificate
```

This shows the top-level Certificate resource documentation.

---

### 2. Explore nested fields

To see fields inside `spec`:
```bash
kubectl explain certificate.spec
```

**You should see** fields like:
- `dnsNames`
- `issuerRef`
- `secretName`
- **`subject`** ← This is what we need!

---

### 3. Extract the subject field documentation

**View the subject field:**
```bash
kubectl explain certificate.spec.subject
```

**You should see** documentation about the X.509 subject field.

---

### 4. Save the documentation to a file

**Method 1: Direct output**
```bash
kubectl explain certificate.spec.subject > ~/subject.yaml
```

**Method 2: With recursive flag (shows all subfields)**
```bash
kubectl explain certificate.spec.subject --recursive > ~/subject.yaml
```

---

### 5. Verify the output

```bash
cat ~/subject.yaml
```

**Expected output includes:**
- `KIND: Certificate`
- `RESOURCE: subject`
- Field descriptions (like `commonName`, `countries`, `organizations`, etc.)

---

### 💡 Hints:

- **kubectl explain** shows built-in API documentation
- Use **dot notation** to access nested fields: `resource.field.subfield`
- The format is: `kubectl explain <resource>.<field>`
- For Certificate resource: `kubectl explain certificate.spec.subject`
- The output should contain documentation about the **subject** field structure

---

### 📋 Quick Reference:

| Command | Purpose |
|---------|---------|
| `kubectl explain certificate` | Top-level Certificate docs |
| `kubectl explain certificate.spec` | Spec field docs |
| `kubectl explain certificate.spec.subject` | Subject field docs |
| `kubectl explain certificate.spec.subject --recursive` | Subject + all subfields |

Click **"Continue"** when you've created `~/subject.yaml`!
