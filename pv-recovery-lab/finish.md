Great job recovering the MariaDB deployment with persistent storage!

You successfully:
- Verified the existing PersistentVolume (mariadb-pv, 500Mi)
- Created PersistentVolumeClaim (mariadb, 250Mi, ReadWriteOnce)
- Edited deployment to add volume and volumeMounts
- Applied the deployment and verified it's running with persistent storage

**Key takeaways:**

**PV/PVC Relationship:**
- PV = Storage resource (cluster-level)
- PVC = Storage request (namespace-level)
- Binding = Automatic matching based on storageClass, accessMode, capacity

**Reclaim Policies:**
- **Retain** - Data preserved after PVC deletion (used in this lab)
- **Delete** - PV and data deleted when PVC is deleted
- **Recycle** - Volume scrubbed and made available again (deprecated)

**Access Modes:**
- **ReadWriteOnce (RWO)** - Single node read-write (most common)
- **ReadOnlyMany (ROX)** - Multiple nodes read-only
- **ReadWriteMany (RWX)** - Multiple nodes read-write

**Volume Types:**
- hostPath - Node's filesystem (testing only)
- emptyDir - Pod-level temporary storage
- PVC - Persistent storage via PV
- ConfigMap/Secret - Configuration data
- NFS, iSCSI, Ceph, Cloud Provider volumes - Production storage

**CKA Exam Tips:**
1. **PVC must match PV**: storageClass, accessMode, and capacity
2. **Namespace**: PVC is namespaced, PV is cluster-wide
3. **volumeMounts** in container, **volumes** in pod spec
4. **claimName** must match PVC name exactly
5. **Verify binding**: Both PV and PVC should show "Bound" status
6. **Test**: Always verify the pod can write to the volume

Well done! PersistentVolumes are essential for stateful applications in Kubernetes and a common CKA exam topic.
