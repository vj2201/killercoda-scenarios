## Task 1: Configure TLS Version

Edit the ConfigMap to only support TLSv1.3.

```bash
kubectl edit cm nginx-config -n nginx-static
```

Find the line with `ssl_protocols` and change it to only include TLSv1.3:

```
ssl_protocols TLSv1.3;
```

Restart the deployment to apply changes:

```bash
kubectl rollout restart deploy/nginx-static -n nginx-static
kubectl rollout status deploy/nginx-static -n nginx-static
```

<details>
<summary>💡 Hint</summary>

The nginx configuration is in the ConfigMap under the `nginx.conf` key. Look for the `ssl_protocols` directive and remove `TLSv1.2` from it.

After editing the ConfigMap, you must restart the deployment for nginx to reload the configuration.
</details>
