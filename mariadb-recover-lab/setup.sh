#!/bin/bash
set -e

echo "[setup] MariaDB recover lab: preparing retained PV and template"

kubectl create namespace mariadb --dry-run=client -o yaml | kubectl apply -f -

# Ensure any previous resources are removed to simulate accidental deletion
kubectl -n mariadb delete deploy mariadb --ignore-not-found
kubectl -n mariadb delete pvc mariadb --ignore-not-found

# Prepare hostPath directory and seed a file to verify persistence
HOSTPATH="/srv/pv/mariadb"
mkdir -p "$HOSTPATH/lab-proof"
echo "this-survived" > "$HOSTPATH/lab-proof/keepme.txt"

# Create a single retained PV (250Mi) without a StorageClass
if ! kubectl get pv mariadb-pv >/dev/null 2>&1; then
  kubectl apply -f - <<YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mariadb-pv
spec:
  capacity:
    storage: 250Mi
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  volumeMode: Filesystem
  hostPath:
    path: $HOSTPATH
YAML
fi

# Provide the deployment template at /root/mariadb-deploy.yaml
cat >/root/mariadb-deploy.yaml <<'YAML'
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
        image: mariadb:11
        env:
        - name: MYSQL_ALLOW_EMPTY_PASSWORD
          value: "yes"
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:
        - name: data
          mountPath: /var/lib/mysql
      volumes:
      - name: data
        emptyDir: {}
YAML

echo "[setup] Done. Edit /root/mariadb-deploy.yaml to use PVC 'mariadb'"

