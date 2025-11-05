> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Gateway API Migration

## Scenario
Migrate an existing Ingress resource to Kubernetes Gateway API while maintaining HTTPS access and routing rules.

## Your Task
1. Create Gateway (web-gateway, HTTPS, host gateway.web.k8s.local, TLS secret web-tls-secret) in web-app namespace
2. Create HTTPRoute (web-route) with same hostname and routing rules in web-app namespace
3. Verify both resources have Accepted/Programmed status

## Success Criteria
- Gateway web-gateway is Programmed
- HTTPRoute web-route is Accepted
- Traffic routes correctly through Gateway API
- All in web-app namespace

Click **"Next"** for the solution.
