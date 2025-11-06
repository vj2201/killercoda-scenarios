> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Migrate Ingress to Gateway API

## Question

You have an existing web application deployed in a Kubernetes cluster using an **Ingress resource named `web`**.

You must **migrate** the existing Ingress configuration to the new **Kubernetes Gateway API**, maintaining the existing HTTPS access configuration.

## Scenario

An Ingress resource exists in the `web-app` namespace routing traffic to a web service. The Gateway API CRDs are installed. You need to create equivalent Gateway API resources.

## Your Task

1. **Inspect** the existing Ingress resource `web` in namespace `web-app`
2. **Create a Gateway** named `web-gateway` with:
   - HTTPS listener on port 443
   - Hostname: `gateway.web.k8s.local`
   - TLS secret: `web-tls-secret`
3. **Create an HTTPRoute** named `web-route` with:
   - Same hostname as the Ingress
   - Same routing rules (path → backend service)
4. **Verify** Gateway is Programmed and HTTPRoute is Accepted

## Success Criteria

- Gateway `web-gateway` status: **Programmed**
- HTTPRoute `web-route` status: **Accepted**
- Traffic routes correctly through Gateway API (same as original Ingress)
- All resources in `web-app` namespace

Click **"Next"** for the solution.
