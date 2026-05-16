# Runbook: Memory Alerts (HostMemoryWarning / HostMemoryCritical)

## What is this alert?
Memory utilization exceeded warning (80%) or critical (90%) thresholds.

## Likely causes
- memory leak
- cache growth
- insufficient host sizing

## First 3 investigation steps
1. Inspect memory panel and trend slope.
2. Inspect process/container RSS growth.
3. Review recent deployment and workload profile changes.

## Resolution
- Restart leaking process.
- Tune cache limits.
- Increase memory or reduce concurrency.

## Rollback guidance
Roll back if memory trend changed right after deployment and keeps climbing.

## Escalation
Escalate to app team + platform when critical > 10m or OOM events occur.
