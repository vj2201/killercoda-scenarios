# Solution

## Edit Deployment

```bash
kubectl edit deploy wordpress
```

Add this sidecar container under `spec.template.spec.containers`:

```yaml
- name: sidecar
  image: busybox:stable
  command: ["/bin/sh", "-c"]
  args:
    - "tail -f /var/log/wordpress.log"
  volumeMounts:
  - name: log-volume
    mountPath: /var/log
```

The `log-volume` emptyDir already exists and is mounted by main-app. Just ensure both containers mount it.

Save and exit (:wq).

## Verify

```bash
# Check deployment has 2 containers
kubectl get deploy wordpress -o jsonpath='{.spec.template.spec.containers[*].name}{"\n"}'
```

Expected: `main-app sidecar`

```bash
# View sidecar logs
kubectl logs deployment/wordpress -c sidecar -f
```

You should see the log output from wordpress.log.

## Explanation

**Sidecar pattern**: Multiple containers in a pod share the same network namespace and volumes. The sidecar reads logs from the shared emptyDir volume that main-app writes to.

**Common sidecar uses**:
- Log shipping (Filebeat, Fluentd)
- Service mesh proxies (Envoy, Linkerd)
- Security scanning
- Configuration sync

✅ **Done!** Your pod now has a sidecar for log aggregation.
