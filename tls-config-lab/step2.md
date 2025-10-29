## Task 2: Add Service IP to /etc/hosts

Get the service IP address:

```bash
kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}'
```

Add the IP to `/etc/hosts`:

```bash
SVC_IP=$(kubectl get svc nginx-service -n nginx-static -o jsonpath='{.spec.clusterIP}')
echo "$SVC_IP ckaquestion.k8s.local" | sudo tee -a /etc/hosts
```

Verify the entry:

```bash
cat /etc/hosts | grep ckaquestion
```

<details>
<summary>💡 Hint</summary>

You can also manually edit `/etc/hosts` with vi or nano:

```bash
sudo vi /etc/hosts
```

Add a line like: `10.96.x.x ckaquestion.k8s.local`
</details>

---

## Task 3: Verify TLS Configuration

Test that TLSv1.2 is rejected:

```bash
curl -vk --tls-max 1.2 https://ckaquestion.k8s.local
```

Expected: Connection should fail with SSL/TLS error.

Test that TLSv1.3 works:

```bash
curl -vk --tlsv1.3 https://ckaquestion.k8s.local
```

Expected: Should return `TLS Configuration Working!`

<details>
<summary>💡 What to look for</summary>

**TLSv1.2 test should fail with:**
```
SSL alert number 70
ssl handshake failure
```

**TLSv1.3 test should succeed with:**
```
< HTTP/1.1 200 OK
TLS Configuration Working!
```

If both tests succeed, the ConfigMap still allows TLSv1.2. Re-check step 1.
</details>

---

**Success criteria:**
- ✅ ConfigMap only has `ssl_protocols TLSv1.3;`
- ✅ Deployment restarted successfully
- ✅ `/etc/hosts` contains service IP mapped to `ckaquestion.k8s.local`
- ✅ TLSv1.2 connection fails
- ✅ TLSv1.3 connection succeeds

You've successfully configured nginx to enforce TLSv1.3 only!
