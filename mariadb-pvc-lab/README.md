# CKA Practice Lab — Recover Deployment with PersistentVolume

This lab helps you practice working with PersistentVolumes (PV) and PersistentVolumeClaims (PVC) to recover a deleted deployment while preserving data - an essential CKA exam skill.

## Scenario

A MariaDB deployment was accidentally deleted. A PersistentVolume exists with retained data. Your tasks are to:

1. Verify the existing PersistentVolume (500Mi, ReadWriteOnce)
2. Create a PersistentVolumeClaim named `mariadb` (250Mi, ReadWriteOnce)
3. Edit the deployment template file to use the PVC
4. Apply the deployment and verify it's running with persistent storage

## Quick Start

**Killercoda (recommended):**
```
https://killercoda.com/vj2201/scenario/pv-recovery-lab
```

**Local cluster:**
```bash
curl -s https://raw.githubusercontent.com/vj2201/killercoda-scenarios/main/pv-recovery-lab/setup.sh | bash
```

## Learning Objectives

- Understanding PersistentVolumes and PersistentVolumeClaims
- PV/PVC binding process
- Configuring volumes in Deployments
- Data persistence and recovery
- Reclaim policies (Retain vs Delete)
- Access modes (ReadWriteOnce, ReadOnlyMany, ReadWriteMany)

## Solution

See `solution/SOLUTION.md` for the complete solution.

## Related CKA Topics

- Storage
- PersistentVolumes
- PersistentVolumeClaims
- Stateful Applications
- Data Recovery
