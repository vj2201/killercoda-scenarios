Wrap-up

- You recreated a PVC (`mariadb`) that matches the retained PV (250Mi, RWO)
- You edited `/root/mariadb-deploy.yaml` to mount the PVC at `/var/lib/mysql`
- The MariaDB deployment rolled out successfully and could access the retained data
- The presence of `lab-proof/keepme.txt` confirms the mount is using the preserved volume

Key checks:
- `kubectl get pv,pvc -A` shows Bound
- `kubectl -n mariadb get deploy,po` shows Ready pods

