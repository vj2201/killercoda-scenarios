Great job configuring resource requests and limits!

You successfully:
- Scaled the WordPress deployment to 0 replicas for safe editing
- Added identical resource requests and limits to both init and main containers
- Scaled back to 3 replicas with fair resource allocation across pods
- Left appropriate overhead on the node (not requesting 100% of allocatable resources)

Key takeaways:
- Init containers and main containers can have different resource requirements, but in this exercise they were identical
- Resource requests affect scheduling; limits affect runtime behavior
- Leaving headroom prevents node resource exhaustion
- Scaling to 0 before editing resources is safer than in-place updates

Next steps:
- Practice with ResourceQuotas and LimitRanges at the namespace level
- Experiment with different request vs limit ratios
- Try setting up VPA (Vertical Pod Autoscaler) for automatic resource tuning
