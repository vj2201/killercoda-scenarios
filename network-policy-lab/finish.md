Congratulations! You've successfully created a least-permissive network policy.

**What you learned:**

1. **Network Policy Basics** - How to control pod-to-pod communication
2. **Least Permissive Principle** - Only allow necessary traffic, deny everything else
3. **Namespace Selectors** - Restricting traffic based on source namespace
4. **Port Restrictions** - Allowing specific ports only
5. **Testing Network Policies** - Verifying allowed and blocked traffic

**Key Concepts:**

- **Default Behavior**: Without NetworkPolicy, all traffic is allowed
- **Deny by Default**: Once a NetworkPolicy selects a pod, all traffic is denied except what's explicitly allowed
- **Policy Location**: NetworkPolicy must be in the namespace of the pods being protected
- **Selectors**: Use `podSelector` to choose which pods the policy applies to
- **Ingress Rules**: Define what traffic is allowed into the pods

**Key Commands:**

- `kubectl get networkpolicy -n <namespace>` - List network policies
- `kubectl describe networkpolicy <name> -n <namespace>` - View policy details
- `kubectl exec -n <namespace> <pod> -- <command>` - Test connectivity

**CKA Exam Tips:**

- Network policies are namespace-scoped resources
- Always test your network policies after creating them
- Use `namespaceSelector` with labels like `kubernetes.io/metadata.name`
- Remember: NetworkPolicy is additive - multiple policies can select the same pods
- Specify both `podSelector` and ingress/egress rules clearly

Great job!
