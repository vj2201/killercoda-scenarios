# CKA Practice Lab — CRD Exploration & kubectl explain

This lab helps you practice working with Custom Resource Definitions (CRDs) and using kubectl explain - essential CKA exam skills.

## Scenario

cert-manager has been installed in the cluster with several CRDs. Your tasks are to:

1. Create a list of all cert-manager CRDs and save it to `/root/resources.yaml`
2. Extract documentation for the `subject` field of the Certificate Custom Resource and save it to `/root/subject.yaml`
3. Use any output format that kubectl supports

## Quick Start

**Killercoda (recommended):**
```
https://killercoda.com/vj2201/scenario/cert-manager-lab
```

**Local cluster:**
```bash
curl -s https://raw.githubusercontent.com/vj2201/killercoda-scenarios/main/cert-manager-lab/setup.sh | bash
```

Then follow the steps in the scenario.

## Learning Objectives

- Understanding Custom Resource Definitions (CRDs)
- Listing and filtering CRDs in a cluster
- Using `kubectl explain` to explore API documentation
- Extracting and saving kubectl output to files
- Working with cert-manager CRDs
- Using output formats: YAML, JSON, text

## Prerequisites

- Basic kubectl knowledge
- Understanding of Kubernetes resources
- Familiarity with file redirection in bash

## Solution

See `solution/SOLUTION.md` for the complete solution and explanation.

## Related CKA Topics

- API Discovery
- Custom Resources
- kubectl explain
- Output formatting
- File operations
- cert-manager (common third-party component)
