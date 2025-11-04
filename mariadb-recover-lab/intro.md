# MariaDB Data Recovery

## Scenario
A MariaDB pod needs to mount a persistent volume at `/var/lib/mysql` to access pre-existing database data including the required proof file.

## Your Task
1. Create a PersistentVolumeClaim (250Mi, RWO)
2. Edit `/root/mariadb-deploy.yaml` to mount PVC at `/var/lib/mysql`
3. Apply the deployment and verify `/var/lib/mysql/lab-proof/keepme.txt` exists

## Success Criteria
- MariaDB pod is running and healthy
- `/var/lib/mysql/lab-proof/keepme.txt` file is accessible inside the container
- PVC is bound and mounted correctly

Click **"Next"** for the solution.
