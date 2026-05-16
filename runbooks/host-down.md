# Runbook: HostDown

## What is this alert?
Blackbox HTTP probe failed for at least 2 minutes.

## Likely causes
- host/network outage
- service crash
- TLS or DNS failure

## First 3 investigation steps
1. Validate host reachability (ping/SSH/service endpoint).
2. Check service/container status.
3. Review recent network/firewall/DNS changes.

## Resolution
- Restore host/network connectivity.
- Restart failed service.
- Fix DNS/TLS config issues.

## Rollback guidance
Rollback if outage follows deployment or infrastructure change.

## Escalation
Escalate to incident commander if outage > 5m for production-critical service.
