You will recover a MariaDB deployment after accidental deletion while preserving data using PersistentVolumes.

**Scenario:**
A user accidentally deleted the MariaDB Deployment in the `mariadb` namespace. The deployment was configured with persistent storage. Your responsibility is to re-establish the deployment while ensuring data is preserved by reusing the available PersistentVolume.

**Tasks:**
1. Verify that a PersistentVolume exists and is retained for reuse (only one PV exists)
2. Create a PersistentVolumeClaim (PVC) named `mariadb` in the mariadb namespace with:
   - Access Mode: ReadWriteOnce
   - Storage: 250Mi
3. Edit the MariaDB Deployment file located at `~/mariadb-deploy.yaml` to use the PVC created
4. Apply the updated Deployment file to the cluster
5. Ensure the MariaDB Deployment is running and stable

**Key Concepts:**
- **PersistentVolume (PV)** - Cluster-level storage resource
- **PersistentVolumeClaim (PVC)** - Request for storage by a user
- **Retain Policy** - PV data is preserved even after PVC deletion
- **Binding** - PVC automatically binds to matching PV
- **Volume Mounts** - How containers access PV storage

The setup has already:
- Created the `mariadb` namespace
- Created a PersistentVolume `mariadb-pv` (500Mi, Available)
- Created deployment template at `/root/mariadb-deploy.yaml`
