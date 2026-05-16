# Runbook: ChangeFailureRateHigh

## What is this alert?
Rolling 7-day change failure rate exceeded 15%.

## Likely causes
- unstable deployment process
- weak pre-merge validation
- poor rollback readiness

## First 3 investigation steps
1. Check recent failed workflow runs and failure patterns.
2. Break failures by service/component.
3. Verify rollback/hotfix count and reasons.

## Resolution
- Stabilize pipeline checks.
- Improve test coverage and release gates.
- Enforce progressive delivery and fast rollback.

## Rollback guidance
Rollback current release if failures map to active rollout and user impact is present.

## Escalation
Escalate to DevOps lead and engineering manager when CFR remains above threshold > 24h.
