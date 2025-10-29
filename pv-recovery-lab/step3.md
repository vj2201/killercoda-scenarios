Edit the deployment file at `/root/mariadb-deploy.yaml` to use the PVC.

Open the file for editing:

`vi /root/mariadb-deploy.yaml`

Or use nano:

`nano /root/mariadb-deploy.yaml`

Add the volume and volumeMounts configuration. The file should look like this:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
  namespace: mariadb
  labels:
    app: mariadb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: mariadb:10.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "password123"
        - name: MYSQL_DATABASE
          value: "testdb"
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: mariadb
```

**What to add:**

1. Under `spec.template.spec.containers[0]`, add `volumeMounts`:
```yaml
        volumeMounts:
        - name: mariadb-storage
          mountPath: /var/lib/mysql
```

2. Under `spec.template.spec`, add `volumes`:
```yaml
      volumes:
      - name: mariadb-storage
        persistentVolumeClaim:
          claimName: mariadb
```

**Key points:**
- `mountPath: /var/lib/mysql` - MariaDB's default data directory
- `claimName: mariadb` - References the PVC you created
- Volume name must match between volumes and volumeMounts

Save the file and verify your changes:

`cat /root/mariadb-deploy.yaml`

Ensure both `volumeMounts` and `volumes` sections are present.

In the next step, you'll apply the deployment.
