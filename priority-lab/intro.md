You will work with Kubernetes PriorityClasses to control pod scheduling priority.

**Scenario:**
You're working in a cluster with an existing deployment named `busybox-logger` running in the `priority` namespace. The cluster already has user-defined PriorityClasses (prefixed with `user-`).

**Tasks:**
1. Inspect existing PriorityClasses and identify user-defined ones (excluding system classes)
2. Create a new PriorityClass named `high-priority` for user workloads with a value exactly one less than the highest existing user-defined priority class
3. Patch the existing deployment `busybox-logger` to use the newly created `high-priority` class

**Key Concepts:**
- PriorityClasses control which pods are scheduled first when resources are limited
- Higher priority values mean higher priority
- System PriorityClasses (like `system-cluster-critical`) have very high values and should not be modified
- User-defined PriorityClasses typically use values below 1000000000

The setup script has already created the namespace, some PriorityClasses, and the deployment.
