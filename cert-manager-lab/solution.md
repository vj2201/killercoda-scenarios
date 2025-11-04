# Solution

## Step 1: List and Export cert-manager CRDs
```bash
kubectl get crd | grep cert-manager
kubectl get crd -o yaml > ~/resources.yaml
cat ~/resources.yaml | head -50
```

## Step 2: Extract Certificate.spec.subject Documentation
```bash
kubectl explain Certificate.spec.subject > ~/subject.yaml
cat ~/subject.yaml
```

## Explanation
CRDs extend Kubernetes with custom resources, and kubectl explain provides access to the cluster's API schema documentation. This allows you to discover available fields without external documentation during the exam.

✅ **Done!** Successfully explored cert-manager CRDs and extracted API documentation.
