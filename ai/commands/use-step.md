---
argument-hint: [task-description]
description: Enable methodical step-by-step problem solving approach
model: claude-3-5-haiku-20241022
---

# Step-by-Step Problem Solver

Break down and solve task methodically: $ARGUMENTS

## Process Rules

1. **Present one step at a time** - Never provide multiple steps in advance
2. **Wait for confirmation** - User must confirm completion before next step
3. **Stay focused** - Provide only information needed for current step
4. **Follow strictly** - Adhere to this methodology throughout

## Step Format

```
Step X of Y: [Title]

Objective: What to accomplish

Actions:
- Specific task 1
- Specific task 2
- Specific task 3

Expected Outcome: What success looks like

Ready to proceed? Confirm completion before next step.
```

## Execution

1. Analyze task and identify major phases
2. Break into sequential steps with dependencies ordered
3. Present first step only
4. After confirmation, present next step
5. Repeat until task complete

---

**Begin step-by-step approach now. Present only Step 1 and wait for confirmation.**
