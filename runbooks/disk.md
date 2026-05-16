# Runbook: Disk Alerts (HostDiskWarning / HostDiskCritical)

## What is this alert?
Disk utilization exceeded warning (75%) or critical (90%).

## Likely causes
- log growth
- retained artifacts
- runaway temp files

## First 3 investigation steps
1. Check filesystem usage by mountpoint.
2. Identify largest paths/files.
3. Validate retention jobs (logs, traces, backups).

## Resolution
- Rotate/prune old logs and artifacts.
- Increase storage if growth is expected.
- Fix retention policies in Loki/Tempo/app logs.

## Rollback guidance
Rollback if release introduced excessive log volume or artifact writes.

## Escalation
Escalate immediately at critical if free space projects < 2h remaining.
