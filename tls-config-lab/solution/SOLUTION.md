# TLS Configuration - Complete Solution

## Task Summary

1. Configure the ConfigMap to only support TLSv1.3
2. Add the service IP to `/etc/hosts` as `ckaquestion.k8s.local`
3. Verify TLSv1.2 fails and TLSv1.3 works

---

## Step 1: Configure TLS Version

### Verify Current Configuration

Check the existing ConfigMap:

```bash
kubectl get cm nginx-config -n nginx-static -o yaml | grep ssl_protocols
```

Output shows:
```
ssl_protocols TLSv1.2 TLSv1.3;
```

### Solution: Edit ConfigMap

**Option 1: Using kubectl edit**

```bash
kubectl edit cm nginx-config -n nginx-static
```

Find the line:
```
ssl_protocols TLSv1.2 TLSv1.3;
```

Change it to:
```
ssl_protocols TLSv1.3;
```

Save and exit.

**Option 2: Using kubectl patch**

```bash
kubectl patch cm nginx-config -n nginx-static --type='json' -p='[
  {
    "op": "replace",
    "path": "/data/nginx.conf",
    "value": "user nginx;\nworker_processes auto;\nerror_log /var/log/nginx/error.log;\npid /run/nginx.pid;\n\nevents {\n    worker_connections 1024;\n}\n\nhttp {\n    log_format main '\''$remote_addr - $remote_user [$time_local] \"$request\" '\''\n                    '\''$status $body_bytes_sent \"$http_referer\" '\''\n                    '\''\"$http_user_agent\" \"$http_x_forwarded_for\"'\'';\n\n    access_log /var/log/nginx/access.log main;\n\n    server {\n        listen 443 ssl;\n        server_name ckaquestion.k8s.local;\n\n        ssl_certificate /etc/nginx/ssl/tls.crt;\n        ssl_certificate_key /etc/nginx/ssl/tls.key;\n        ssl_protocols TLSv1.3;\n        ssl_prefer_server_ciphers on;\n\n        location / {\n            return 200 '\''TLS Configuration Working!\\n'\'';\n            add_header Content-Type text/plain;\n        }\n    }\n}\n"
  }
]'
```

**Option 3: Apply Solution File**

```bash
kubectl apply -f solution/nginx-config.solution.yaml
```

### Restart Deployment

The ConfigMap change requires a deployment restart:

```bash
kubectl rollout restart deploy/nginx-static -n nginx-static
```

Wait for rollout to complete:

```bash
kubectl rollout status deploy/nginx-static -n nginx-static
```

Output:
```
deployment "nginx-static" successfully rolled out
```

Verify pod is running:

```bash
kubectl get pods -n nginx-static
```

---

## Step 2: Add Service IP to /etc/hosts

### Get Service IP

```bash
kubectl get svc nginx-service -n nginx-static
```

Or get just the ClusterIP:

```bash
kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}'
```

Example output: `10.96.123.45`

### Add to /etc/hosts

**Option 1: One-liner**

```bash
SVC_IP=$(kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}')
echo "$SVC_IP ckaquestion.k8s.local" | sudo tee -a /etc/hosts
```

**Option 2: Manual edit**

```bash
sudo vi /etc/hosts
```

Add line (replace with actual IP):
```
10.96.123.45 ckaquestion.k8s.local
```

### Verify /etc/hosts Entry

```bash
cat /etc/hosts | grep ckaquestion
```

Output:
```
10.96.123.45 ckaquestion.k8s.local
```

Test DNS resolution:

```bash
getent hosts ckaquestion.k8s.local
```

---

## Step 3: Verify TLS Configuration

### Test TLSv1.2 (Should Fail)

```bash
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local
```

Expected output (connection failure):
```
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS alert, protocol version (582):
* error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version
* Closing connection 0
curl: (35) error:1409442E:SSL routines:ssl3_read_bytes:tlsv1 alert protocol version
```

Or:
```
* SSL alert number 70
* SSL alert number 70
* ssl handshake failure
```

### Test TLSv1.3 (Should Succeed)

```bash
curl -vk --tlsv1.3 https://ckaquestion.k8s.local
```

Expected output (success):
```
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384
...
< HTTP/1.1 200 OK
...
TLS Configuration Working!
```

---

## Verification Checklist

Run these commands to verify everything is correct:

```bash
# 1. Check ConfigMap only has TLSv1.3
kubectl get cm nginx-config -n nginx-static -o yaml | grep ssl_protocols

# 2. Check deployment is running
kubectl get deploy nginx-static -n nginx-static

# 3. Check /etc/hosts entry
grep ckaquestion /etc/hosts

# 4. Test TLSv1.2 fails
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local 2>&1 | grep -i "error\|alert\|fail"

# 5. Test TLSv1.3 succeeds
curl -vk --tlsv1.3 https://ckaquestion.k8s.local 2>&1 | grep "TLS Configuration Working"
```

Expected results:
- ✅ ConfigMap shows: `ssl_protocols TLSv1.3;`
- ✅ Deployment is Available with 1/1 replicas
- ✅ /etc/hosts contains service IP mapping
- ✅ TLSv1.2 test shows error/alert/failure
- ✅ TLSv1.3 test returns `TLS Configuration Working!`

---

## Key Points

**ConfigMap Changes:**
- ConfigMap edits do NOT automatically update running pods
- Must restart deployment: `kubectl rollout restart`
- Use `kubectl rollout status` to wait for completion

**TLS Protocol Configuration:**
- `ssl_protocols` directive controls supported TLS versions
- nginx default includes TLSv1, TLSv1.1, TLSv1.2
- Best practice: Only enable TLSv1.2 and TLSv1.3 (or TLSv1.3 only)

**/etc/hosts:**
- Local DNS resolution file
- Format: `IP_ADDRESS hostname`
- Useful for testing without DNS servers
- Changes take effect immediately (no restart needed)

**curl TLS Testing:**
- `--tlsv1.3` - Force TLS 1.3
- `--tls-max 1.2` - Maximum TLS 1.2
- `-v` - Verbose output showing TLS handshake
- `-k` - Skip certificate verification (for self-signed certs)

---

## Common Issues

**Issue: TLSv1.2 still works after editing ConfigMap**

Solution: Restart the deployment
```bash
kubectl rollout restart deploy/nginx-static -n nginx-static
kubectl rollout status deploy/nginx-static -n nginx-static
```

**Issue: curl returns "Could not resolve host"**

Solution: Verify /etc/hosts entry
```bash
grep ckaquestion /etc/hosts
# Should show: <IP> ckaquestion.k8s.local
```

**Issue: Both TLS versions fail**

Solution: Check pod logs for nginx errors
```bash
kubectl logs -n nginx-static -l app=nginx-static
```

Common error: Syntax error in nginx.conf (missing semicolon, etc.)

**Issue: Connection refused**

Solution: Verify service and pod are running
```bash
kubectl get svc,pods -n nginx-static
```

---

## CKA Exam Tips

1. **ConfigMap changes require pod restart** - Don't forget `kubectl rollout restart`
2. **Use kubectl edit for quick changes** - Faster than applying files
3. **Verify with actual tests** - Don't assume changes worked
4. **Check logs if something fails** - `kubectl logs` is your friend
5. **/etc/hosts is persistent** - Entries survive pod restarts (useful for testing)

---

## Time-Saving Commands

```bash
# One-liner to edit, restart, and verify
kubectl edit cm nginx-config -n nginx-static && \
  kubectl rollout restart deploy/nginx-static -n nginx-static && \
  kubectl rollout status deploy/nginx-static -n nginx-static

# Quick /etc/hosts update
echo "$(kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}') ckaquestion.k8s.local" | sudo tee -a /etc/hosts

# Test both versions at once
echo "Testing TLSv1.2 (should fail):" && \
  curl -vk --tls-max 1.2 https://ckaquestion.k8s.local 2>&1 | grep -i "error\|alert" && \
  echo "Testing TLSv1.3 (should work):" && \
  curl -vk --tlsv1.3 https://ckaquestion.k8s.local
```

---

**Congratulations!** You've successfully configured nginx to enforce TLSv1.3 only and verified the configuration.
