Congratulations! You've successfully configured nginx to enforce TLSv1.3 only.

**What you learned:**

1. **ConfigMap editing** - Modifying application configuration via ConfigMaps
2. **TLS protocol configuration** - Restricting supported TLS versions in nginx
3. **Deployment restart** - Applying ConfigMap changes to running pods
4. **/etc/hosts configuration** - Adding custom DNS entries for testing
5. **TLS verification** - Using curl to test specific TLS protocol versions

**Key Commands:**

- `kubectl edit cm <name> -n <namespace>` - Edit ConfigMap
- `kubectl rollout restart deploy/<name>` - Restart deployment
- `kubectl get svc <name> -o jsonpath='{.spec.clusterIP}'` - Get service IP
- `curl -vk --tls-max 1.2 <url>` - Test with max TLS 1.2
- `curl -vk --tlsv1.3 <url>` - Test with TLS 1.3

**CKA Exam Tips:**

- Always restart deployments after editing ConfigMaps (changes don't auto-apply)
- Use `kubectl rollout status` to wait for restart completion
- Verify configuration changes with actual connectivity tests
- `/etc/hosts` entries are useful for quick DNS testing without DNS servers
- Use `-v` (verbose) flag with curl to see TLS handshake details

Great job!
