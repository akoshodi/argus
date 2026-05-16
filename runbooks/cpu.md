# Runbook: CPU Alerts (HostHighCpuWarning / HostHighCpuCritical)

## What is this alert?
Host CPU usage exceeded warning (80% for 5m) or critical (90% for 10m).

## Likely causes
- traffic spike
- runaway process
- noisy neighbor workload

## First 3 investigation steps
1. Check CPU panel on Node Exporter dashboard.
2. Identify top CPU-consuming processes (`top`, `pidstat`, or container stats).
3. Correlate with recent deploys and error/latency spikes.

## Resolution
- Scale out workload or increase resources.
- Restart or throttle runaway process.
- Roll back problematic deployment if tied to release.

## Rollback guidance
Roll back if CPU increase starts immediately after deploy and user-facing SLO degrades.

## Escalation
Escalate to platform on-call if critical persists > 15m or spreads across hosts.
