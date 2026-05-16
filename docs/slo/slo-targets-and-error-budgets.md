# SLO Targets and Error Budgets

## Availability SLO
- Target: 99.5% successful HTTP probes over rolling 30 days.
- Rationale: balances user trust with practical operational overhead for a non-life-critical API.
- Formula:

```text
Error budget = (1 - 0.995) * 30 days = 0.15 days = 3.6 hours
```

## Latency SLO
- Target: 95% of successful requests complete under 500ms.
- Rationale: keeps interactive API behavior responsive while tolerating short spikes.

## Error Rate SLO
- Target: 99% of requests are non-5xx over rolling 30 days.
- Rationale: protects customer confidence and supports sustainable release cadence.
- Formula:

```text
Error budget = (1 - 0.99) * 30 days = 0.3 days = 7.2 hours
```

## Burn-rate thresholds
- Fast burn critical: 14.4x (2% budget in 1h).
- Slow burn warning: 5x (5% budget in 6h).

## Review cadence
- Weekly reliability review (engineering + platform).
- Monthly SLO target calibration with product stakeholders.
