# CRD Exploration with kubectl explain

## Scenario
cert-manager is installed with custom resources. You need to explore CRDs and extract API documentation.

## Your Task
1. Export all cert-manager CRDs to `~/resources.yaml`
2. Extract Certificate.spec.subject documentation to `~/subject.yaml` using kubectl explain
3. Verify both files contain the correct information

## Success Criteria
- `~/resources.yaml` contains all cert-manager CustomResourceDefinitions
- `~/subject.yaml` contains the subject field documentation
- Both files are readable and properly formatted

Click **"Next"** for the solution.
