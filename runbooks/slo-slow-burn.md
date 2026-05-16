# Runbook: SLOSlowBurnRateWarning

## What is this alert?
Error budget burning at >= 5x in a 6-hour window.

## Likely causes
- sustained low-grade errors
- recurring partial failures
- degraded dependency performance

## First 3 investigation steps
1. Inspect 6h trend for errors and latency.
2. Compare routes/services contributing most failures.
3. Correlate with deploys and scheduled jobs.

## Resolution
- Prioritize remediation before escalation to critical burn.
- Schedule near-term fix and add temporary guardrails.

## Rollback guidance
Rollback if signal is deployment-correlated and persisting.

## Escalation
Escalate to service owner if unresolved within one on-call shift.
