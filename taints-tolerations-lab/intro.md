# Configure Taints and Tolerations

## Scenario
You have a two-node cluster. Node `node01` needs to be reserved for special workloads only.

## Your Task
1. Add a taint to `node01` with key=`PERMISSION`, value=`granted`, effect=`NoSchedule`
2. Create a pod named `nginx` that can be scheduled on `node01` by adding the correct toleration

## Success Criteria
- Taint exists on node01
- Pod `nginx` is running on node01
- Pods without the toleration cannot be scheduled on node01

Click **"Next"** for the solution.
