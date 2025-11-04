# CNI Installation with NetworkPolicy

## Scenario
Install a Container Network Interface that enables both pod-to-pod connectivity and NetworkPolicy enforcement.

## Your Task
1. Install Calico operator from manifest
2. Create Calico Installation with VXLAN encapsulation
3. Verify Calico pods are running and NetworkPolicy enforcement works

## Success Criteria
- Calico pods running in calico-system namespace
- Pods can communicate across nodes
- NetworkPolicy rules are enforced
- Default-deny policy blocks traffic until explicit allow is created

Click **"Next"** for the solution.
