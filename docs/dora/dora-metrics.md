# DORA Metrics and Toil Reduction

## Metrics Definitions
- Deployment Frequency (DF): successful deployments per day.
- Lead Time for Changes (LTC): time from commit to production confirmation.
- Change Failure Rate (CFR): failed deployments / total deployments.
- Mean Time to Restore (MTTR): duration between incident detection and service recovery.

## LTC Sub-interval Instrumentation
LTC is tracked with explicit sub-interval metrics:
- `dora_ltc_commit_to_trigger_seconds`
- `dora_ltc_trigger_to_pipeline_complete_seconds`
- `dora_ltc_pipeline_complete_to_deploy_confirmed_seconds`
- `dora_ltc_total_seconds`

These are exported via Node Exporter textfile collector (`metrics/incident.prom`) and can be updated with `scripts/record_ltc.sh`.

## Benchmarks
- DF Classification:
  - Elite: >= 1 deployment/day
  - High: >= 1 deployment/week
  - Medium: >= 1 deployment/month
  - Low: < 1 deployment/month

## CFR SLO
- Threshold: CFR must remain <= 15% rolling 7d.
- Alert fires when CFR > 15%.

## MTTR Target
- Target: MTTR <= 60 minutes rolling 7d average.
- MTTR source metric: `incident_mttr_minutes`.
- Manual intervention overhead source metric: `incident_manual_intervention_minutes`.
- Update helper: `scripts/record_mttr.sh <detected_unix_ts> <resolved_unix_ts>`.

## Toil Identified
1. Manual alert triage notes in chat.
- Automation: Slack payload includes direct Grafana/runbook links and standardized fields.
- Implemented: Yes.

2. Manual evidence collection for game day and PIR.
- Automation: scenario checklist template with required screenshots and timeline fields.
- Implemented: Yes (see docs/gameday/scenarios.md and docs/incident/pir-template.md).
