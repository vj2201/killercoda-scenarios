> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Configure TLS Protocol Version

## Scenario
An nginx deployment in namespace `nginx-static` uses a ConfigMap for configuration. It currently supports TLS 1.2 and 1.3.

## Your Task
1. Edit the ConfigMap to enforce TLS 1.3 ONLY
2. Restart the deployment to apply changes
3. Add service IP to /etc/hosts as `ckaquestion.k8s.local`
4. Verify TLS 1.2 fails and TLS 1.3 succeeds

## Success Criteria
- ConfigMap has `ssl_protocols TLSv1.3;`
- curl with --tls-max 1.2 fails
- curl with --tlsv1.3 succeeds

Click **"Next"** for the solution.
