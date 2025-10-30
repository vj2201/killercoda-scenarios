Recover a deleted MariaDB Deployment by reusing an existing retained PersistentVolume.

Scenario:
- Namespace `mariadb` exists but the MariaDB Deployment was deleted by accident.
- Exactly one PersistentVolume exists, with `persistentVolumeReclaimPolicy: Retain` and capacity 250Mi.
- A deployment spec is provided at `/root/mariadb-deploy.yaml` and must be edited to use a new PVC.

Task Summary:
1) Create a PVC named `mariadb` in the `mariadb` namespace:
   - AccessMode: ReadWriteOnce
   - Storage: 250Mi
2) Edit `/root/mariadb-deploy.yaml` to mount the PVC
3) Apply the deployment and ensure it is running and stable
4) Verify data appears from the retained volume (a seeded file is provided)

