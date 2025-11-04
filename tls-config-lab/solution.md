# Solution

## Step 1: Edit ConfigMap

```bash
kubectl edit cm nginx-config -n nginx-static
```

Find the line with `ssl_protocols` and change it to:
```
ssl_protocols TLSv1.3;
```

Save and exit.

## Step 2: Restart Deployment

```bash
kubectl rollout restart deploy/nginx-static -n nginx-static
kubectl rollout status deploy/nginx-static -n nginx-static
```

## Step 3: Add to /etc/hosts

```bash
SVC_IP=$(kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}')
echo "$SVC_IP ckaquestion.k8s.local" | sudo tee -a /etc/hosts
```

## Step 4: Test TLS Versions

```bash
# Should FAIL (TLS 1.2 not supported)
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local 2>&1 | grep -i "ssl\|tls"

# Should SUCCEED (TLS 1.3 supported)
curl -vk --tlsv1.3 https://ckaquestion.k8s.local
```

Expected: First command fails with SSL/TLS error. Second succeeds with "TLS Configuration Working!"

## Explanation

**ConfigMap** stores nginx configuration. Changing `ssl_protocols` restricts TLS versions. Restart applies the new config by recreating pods with updated ConfigMap mounts.

**TLS 1.3** is more secure than 1.2 (better encryption, faster handshake).

✅ **Done!** Your nginx now enforces TLS 1.3 only.
