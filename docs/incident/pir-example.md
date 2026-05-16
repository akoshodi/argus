# Blameless PIR: Latency Spike During Deployment

## Incident Summary
- Incident ID: PIR-2026-05-16-01
- Date/Time: 2026-05-16 10:05-10:42 UTC
- Service: sample-api
- Severity: SEV-2
- Duration: 37 minutes

## Timeline
- 10:05: deployment started.
- 10:08: p95 latency crossed 500ms.
- 10:10: SLOFastBurnRateCritical alert fired in #DevOps-Alerts.
- 10:12: on-call acknowledged and opened unified dashboard.
- 10:16: Tempo trace showed long downstream call path.
- 10:20: rollback initiated.
- 10:27: latency normalized.
- 10:42: post-incident verification completed.

## Root Cause
A code path introduced synchronous I/O in the request handler, increasing tail latency and causing retries.

## Impact
Approx. 18% of requests exceeded latency objective during the event window.

## Detection Gap
Alert worked, but commit metadata was missing in deployment annotation, increasing triage time.

## Action Items
- [ ] Add deployment annotations with commit SHA to Grafana (Owner: Platform, Due: 2026-05-20)
- [ ] Add pre-deploy latency smoke test gate in CI (Owner: DevOps, Due: 2026-05-24)
- [ ] Expand runbook rollback criteria examples (Owner: App Team, Due: 2026-05-21)
