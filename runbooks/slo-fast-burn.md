# Runbook: SLOFastBurnRateCritical

## What is this alert?
Error budget is burning at >= 14.4x in a 1-hour window.

## Likely causes
- severe error spike
- major latency regression
- dependency outage

## First 3 investigation steps
1. Open Unified Observability dashboard and inspect error + latency spike window.
2. Drill into Loki logs and Tempo traces for failed route/service.
3. Check deployment and dependency health around onset time.

## Resolution
- Mitigate impact quickly (rollback, feature flag off, traffic shaping).
- Patch root cause and verify burn-rate reduction.

## Rollback guidance
Immediate rollback is recommended if burn started right after deployment.

## Escalation
Page incident commander immediately. Treat as active user-impact incident.
