# Runbook: MTTRExceeded

## What is this alert?
7-day average MTTR is above 60 minutes.

## Likely causes
- delayed detection or ownership ambiguity
- missing runbook steps
- manual incident handling toil

## First 3 investigation steps
1. Review last incidents and timeline stages.
2. Identify where response time was lost (detect, diagnose, mitigate, verify).
3. Verify alert payload quality and runbook linkage.

## Resolution
- Improve alert precision and ownership routing.
- Automate repetitive mitigation steps.
- Run incident drills to reduce coordination delays.

## Rollback guidance
Not directly applicable unless MTTR spike is tied to unstable release pattern.

## Escalation
Escalate to platform manager for process-level corrective action planning.
