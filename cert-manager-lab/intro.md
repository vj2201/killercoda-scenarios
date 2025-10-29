You will work with Custom Resource Definitions (CRDs) and use kubectl to extract API documentation.

**Scenario:**
cert-manager has been installed in the cluster, which includes several CRDs for managing certificates. You need to explore these CRDs and extract documentation.

**Tasks:**
1. Create a list of all cert-manager CRDs and save it to `/root/resources.yaml`
2. Using kubectl, extract the documentation for the `subject` specification field of the Certificate Custom Resource and save it to `/root/subject.yaml`
3. You may use any output format that kubectl supports

**Key Concepts:**
- **CRDs** (Custom Resource Definitions) extend Kubernetes API with custom resources
- `kubectl get crd` lists all CRDs in the cluster
- `kubectl explain` shows API documentation for resources and fields
- Output formats: `-o yaml`, `-o json`, `-o wide`, etc.
- Field paths use dot notation: `Certificate.spec.subject`

**About cert-manager:**
- cert-manager automates certificate management in Kubernetes
- Provides CRDs: Certificate, Issuer, ClusterIssuer, CertificateRequest, etc.
- Commonly used for TLS/SSL certificate automation

The setup script has already installed cert-manager with all its CRDs.
