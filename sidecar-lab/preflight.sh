#!/bin/sh
set -e

echo "=== preflight start: $(date) ==="
echo "[info] user: $(id -un)"
echo "[info] home: $HOME"
echo "[info] kube-context: $(kubectl config current-context 2>/dev/null || echo unknown)"
echo "[info] listing /root"
ls -l /root 2>/dev/null || true

# Ensure kubectl is usable and a node is Ready (best-effort)
echo "[info] waiting for Kubernetes to be Ready..."
for i in $(seq 1 60); do
  if kubectl get nodes --no-headers 2>/dev/null | grep -q " Ready "; then
    echo "[info] cluster Ready"
    break
  fi
  sleep 2
done

# If deployment already exists, show status and exit
if kubectl get deploy synergy-deployment >/dev/null 2>&1; then
  echo "[info] synergy-deployment already present"
  kubectl get deploy,po -l app=synergy || true
  echo "=== preflight end: $(date) ==="
  exit 0
fi

if [ -x /root/setup.sh ]; then
  echo "[info] running /root/setup.sh"
  bash /root/setup.sh || true
else
  echo "[warn] /root/setup.sh not found; applying inline manifest fallback"
  kubectl apply -f - <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: synergy-deployment
  labels:
    app: synergy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: synergy
  template:
    metadata:
      labels:
        app: synergy
    spec:
      containers:
      - name: main-app
        image: busybox:stable
        command: ["/bin/sh", "-c"]
        args:
          - while true; do echo "Main app writing logs..." >> /var/log/synergy-deployment.log; sleep 5; done
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
      volumes:
      - name: log-volume
        emptyDir: {}
YAML
  kubectl rollout status deploy/synergy-deployment --timeout=120s || true
fi

kubectl get deploy,po -l app=synergy || true
echo "=== preflight end: $(date) ==="

