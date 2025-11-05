> 💡 **Free CKA labs take time to create!** Please [subscribe to my YouTube channel](https://youtube.com/channel/UC2ckWW5aAtV0KISxk6g8rCg?sub_confirmation=1) and [buy me a coffee](https://buymeacoffee.com/vjaarohi) ☕ to support more content!

# Configure PriorityClass

## Scenario
You have a deployment `busybox-logger` in namespace `priority`. The cluster has two user-defined PriorityClasses:
- `user-medium-priority` (value: 1000)
- `user-normal-priority` (value: 500)

## Your Task
1. Create a PriorityClass named `high-priority` with value **999** (one less than the highest)
2. Update the `busybox-logger` deployment to use this new PriorityClass

## Success Criteria
- PriorityClass `high-priority` exists with value 999
- Deployment pods run with `priorityClassName: high-priority`

Click **"Next"** to see the solution.
