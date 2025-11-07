# Congratulations! 🎉

You've successfully completed the NetworkPolicy lab!

## What You Learned

In this lab, you:

✅ **Inspected resources** to discover labels and ports using kubectl commands
✅ **Created a NetworkPolicy** with proper selectors and rules
✅ **Tested network isolation** to verify the policy works correctly
✅ **Understood the mapping** between discovered values and NetworkPolicy fields

## Key Takeaways

### NetworkPolicy Essentials

- **podSelector**: Targets specific pods using labels
- **namespaceSelector**: Filters traffic by source namespace
- **ingress/egress**: Controls incoming/outgoing traffic
- **Default Deny**: NetworkPolicies create implicit deny for unmatched traffic

### Discovery Process

Always inspect your environment first:
1. `kubectl get pods --show-labels` → Find pod labels
2. `kubectl get namespace -o yaml` → Find namespace labels
3. `kubectl get svc` → Find service ports

### CKA Exam Tips

- NetworkPolicy is a common CKA exam topic
- Practice creating policies from scratch
- Remember: once a NetworkPolicy exists, it creates default deny
- Test your policies with `kubectl exec` and connectivity tests
- Use `kubectl describe networkpolicy` to debug

---

## Next Steps

Want more practice? Try these challenges:

1. **Create an egress policy** to control outgoing traffic from backend
2. **Add multiple namespaces** to the allowed sources
3. **Block specific IP ranges** using ipBlock selectors
4. **Combine multiple policies** on the same pod

---

## Resources

- [Kubernetes NetworkPolicy Docs](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [NetworkPolicy Recipes](https://github.com/ahmetb/kubernetes-network-policy-recipes)
- [CKA Exam Curriculum](https://github.com/cncf/curriculum)

---

> 💡 **Enjoyed this lab?** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more free CKA labs!

Thank you for practicing with this lab. Good luck on your CKA exam! 🚀
