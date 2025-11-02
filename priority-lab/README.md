# CKA Practice Lab — PriorityClass Configuration

This lab helps you practice working with Kubernetes PriorityClasses - a common CKA exam topic.

## Scenario

You're working in a cluster with an existing deployment named `busybox-logger` in the `priority` namespace. The cluster has user-defined PriorityClasses (with `user-` prefix). Your task is to:

1. Inspect existing PriorityClasses and identify the highest user-defined priority value
2. Create a new PriorityClass named `high-priority` with value exactly one less than the highest
3. Patch the deployment to use the new PriorityClass

## Quick Start

**Killercoda (recommended):**
```
https://killercoda.com/vj2201/scenario/priority-lab
```

**Local cluster:**
```bash
curl -s https://raw.githubusercontent.com/vj2201/killercoda-scenarios/main/priority-lab/setup.sh | bash
```

Then follow the steps in the scenario.

## Learning Objectives

- Understanding PriorityClasses and their role in scheduling
- Distinguishing between system and user-defined priority classes
- Creating and configuring PriorityClasses
- Patching deployments to assign priority classes
- Verifying pod priority assignments

## Solution

See `solution/SOLUTION.md` for the complete solution and explanation.

## Related CKA Topics

- Pod Scheduling
- Resource Management
- Cluster Maintenance
- Workload Priority and Preemption
