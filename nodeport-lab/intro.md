> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Configure NodePort Service

## Scenario
A deployment `nodeport-deployment` exists in namespace `relative` with nginx:1.24 but has NO `containerPort` defined.

## Your Task
1. Edit the deployment to add `containerPort: 80` with name `http`
2. Create a NodePort Service named `nodeport-service` exposing port 30080

## Success Criteria
- Deployment has containerPort 80 configured
- Service exists with NodePort 30080
- Can curl http://NODE_IP:30080 successfully

Click **"Next"** for the solution.
