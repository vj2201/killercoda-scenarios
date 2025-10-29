Great job working with Kubernetes PriorityClasses!

You successfully:
- Inspected existing PriorityClasses and distinguished between system and user-defined classes
- Identified the highest user-defined priority value
- Created a new PriorityClass named `high-priority` with the correct value (one less than the highest)
- Patched the `busybox-logger` deployment to use the new PriorityClass
- Verified pods are running with the assigned priority

**Key takeaways:**
- PriorityClasses are cluster-scoped resources that define pod scheduling priority
- Higher priority values mean higher priority (counter-intuitive but important!)
- System PriorityClasses have very high values and should not be modified
- User-defined classes typically use values below 1,000,000,000
- Setting a PriorityClass on a deployment triggers a rollout with new pods

**How priorities affect scheduling:**
1. **Pod Scheduling**: When resources are limited, higher-priority pods are scheduled before lower-priority ones
2. **Preemption**: Higher-priority pending pods can cause lower-priority running pods to be evicted
3. **Resource Quotas**: Priority can affect resource quota enforcement
4. **Quality of Service**: Works alongside QoS classes (Guaranteed, Burstable, BestEffort)

**Next steps to explore:**
- Create a PriorityClass with `globalDefault: true` to set cluster-wide default priority
- Test preemption by creating high-priority pods on a resource-constrained node
- Combine PriorityClasses with ResourceQuotas for multi-tenant clusters
- Use `preemptionPolicy: Never` to prevent a PriorityClass from preempting other pods
- Practice with Pod Disruption Budgets (PDBs) to control preemption behavior

**Real-world use cases:**
- Critical system workloads (monitoring, logging agents)
- Production vs. development environment separation
- Batch jobs vs. user-facing services
- Time-sensitive workloads during peak hours
