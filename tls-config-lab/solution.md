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

⚠️ **IMPORTANT:** Note the `https://` protocol and `--tlsv1.2` syntax (two dashes, with 'v')!

```bash
# Test TLS 1.2 (should FAIL - connection refused)
curl -vk --tlsv1.2 https://ckaquestion.k8s.local
```

Expected: `SSL routines:ssl_choose_client_version:unsupported protocol` or connection error

```bash
# Test TLS 1.3 (should SUCCEED)
curl -vk --tlsv1.3 https://ckaquestion.k8s.local
```

Expected output:
```
TLS Configuration Working!
```

### Common Mistakes to Avoid:

❌ **WRONG**: `curl -vk tls1.2 cka.k8s.local` (missing `--`, missing `https://`, wrong hostname)
❌ **WRONG**: `curl -vk --tls1.2 http://ckaquestion.k8s.local` (missing 'v', wrong protocol)
✅ **CORRECT**: `curl -vk --tlsv1.2 https://ckaquestion.k8s.local`

### If Commands Don't Work:

1. **Verify /etc/hosts entry:**
   ```bash
   grep ckaquestion /etc/hosts
   ```
   Should show: `10.x.x.x ckaquestion.k8s.local`

2. **Check nginx is running:**
   ```bash
   kubectl get pods -n nginx-static
   ```

3. **Verify service IP:**
   ```bash
   kubectl get svc nginx-service -n nginx-static
   ```

## Explanation

**ConfigMap** stores nginx configuration. Changing `ssl_protocols` restricts TLS versions. Restart applies the new config by recreating pods with updated ConfigMap mounts.

**TLS 1.3** is more secure than 1.2 (better encryption, faster handshake).

✅ **Done!** Your nginx now enforces TLS 1.3 only.
