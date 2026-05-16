# Alert Routing, Inhibition, and Silencing

## Routing Tree
- Root route groups by `alertname`, `service`, `severity`.
- Critical alerts are routed to `slack-critical` and continue for additional matching.
- CI/CD alerts route to `slack-cicd`.
- All others go to `slack-default`.

## Inhibition
- If `HostDown` is firing for a host, suppress noisy host-level CPU/memory alerts for the same instance.

## Silencing
Use Alertmanager UI or API to apply temporary silences:
- During maintenance windows.
- During planned disruptive tests.
- With explicit start/end times and ticket reference.

Required silence fields:
- matcher set (service/instance/severity)
- creator
- comment with reason and ticket
- expiry time
