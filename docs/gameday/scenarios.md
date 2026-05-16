# Game Day Scenarios and Evidence Checklist

## Scenario 1: Deployment Failure
1. Trigger a failing GitHub Actions deployment.
2. Confirm DORA dashboard updates deployment + failure metrics.
3. Confirm `ChangeFailureRateHigh` alert in Slack.
4. Capture screenshots:
- trigger evidence
- failing pipeline
- CFR panel change
- Slack firing and resolved alerts

## Scenario 2: Latency Injection
1. Generate latency via `GET /work?slow=true` load.
2. Observe p95 latency SLI degradation.
3. Confirm burn rate increase and `SLOFastBurnRateCritical` alert.
4. Drill into logs (Loki) and traces (Tempo) from same window.
5. Capture screenshots:
- latency panel spike
- burn-rate panel
- Slack alert payload
- trace view
- recovery state

## Scenario 3: Resource Pressure
1. Create CPU or memory pressure on host.
2. Verify warning then critical alert sequence.
3. Remove pressure and verify resolved notifications.
4. Capture screenshots:
- warning alert
- critical alert
- dashboard saturation metrics
- resolved notification

## Timeline Template
- Trigger time:
- Detection time:
- Alert time:
- First action:
- Recovery time:
- Total MTTR:
