# Production-Grade Observability Platform (LGTM + DORA + SLOs)

This repository implements a production-style observability and reliability platform.

## Stack
- Prometheus: metrics collection and alert evaluation
- Loki: log aggregation and querying
- Tempo: distributed tracing backend
- Grafana: unified dashboards and drill-down workflow
- Alertmanager: routing, grouping, inhibition, and Slack notifications
- Node Exporter: host metrics (CPU, memory, disk, network)
- Blackbox Exporter: uptime and response probing
- OpenTelemetry Collector: ingest OTLP logs/traces, forward to Loki/Tempo
- GitHub Actions Exporter: CI/CD metrics for DORA dashboard
- Instrumented sample service: FastAPI with OTel traces + Prometheus metrics

## Architecture and Data Flow
1. Exporters and app metrics are scraped by Prometheus.
2. App traces are emitted through OTLP to OTel Collector, then sent to Tempo.
3. Application/system logs are ingested by OTel Collector and pushed to Loki.
4. Grafana correlates metrics, logs, and traces.
5. Prometheus alert rules trigger Alertmanager routes to #DevOps-Alerts.

## One-Command Deployment (IaC)
The stack is deployed by Terraform invoking Docker Compose, with all config in version-controlled files.

Prerequisites:
- Docker + Docker Compose
- Terraform >= 1.5

Setup:
1. Copy `.env.example` to `.env` and fill required values.
2. Run one command from repository root:

```bash
terraform -chdir=terraform init && terraform -chdir=terraform apply -auto-approve -var='project_root=<ABSOLUTE_REPO_PATH>'
```

PowerShell example:

```powershell
terraform -chdir=terraform init; terraform -chdir=terraform apply -auto-approve -var "project_root=$PWD"
```

Destroy:

```bash
terraform -chdir=terraform destroy -auto-approve -var='project_root=<ABSOLUTE_REPO_PATH>'
```

## Configuration as Code (Non-UI)
- Prometheus scrape + rules: `config/prometheus/prometheus.yml`, `config/prometheus/alerts.yml`
- Loki config + retention: `config/loki/loki.yaml`
- Tempo config + retention: `config/tempo/tempo.yaml`
- OTel Collector pipelines: `config/otel/config.yaml`
- Alertmanager routes/inhibition/templates: `config/alertmanager/alertmanager.yml`, `templates/slack.tmpl`
- Grafana datasources + dashboards provisioning: `grafana/provisioning/**`
- Dashboards JSON: `grafana/dashboards/*.json`

## Retention Policy
- Prometheus TSDB retention: 30 days
- Loki log retention: 7 days
- Tempo trace retention: 7 days

## Incident and DORA Supplemental Metrics
This stack exposes MTTR and LTC sub-intervals using Node Exporter textfile collector metrics in `metrics/incident.prom`.

- MTTR metric: `incident_mttr_minutes`
- Manual overhead metric: `incident_manual_intervention_minutes`
- LTC sub-intervals:
  - `dora_ltc_commit_to_trigger_seconds`
  - `dora_ltc_trigger_to_pipeline_complete_seconds`
  - `dora_ltc_pipeline_complete_to_deploy_confirmed_seconds`
  - `dora_ltc_total_seconds`

Update helper scripts:

```bash
./scripts/record_mttr.sh <detected_unix_ts> <resolved_unix_ts>
./scripts/record_ltc.sh <commit_to_trigger_s> <trigger_to_complete_s> <complete_to_confirmed_s>
```

## Required Dashboards
1. DORA Metrics Dashboard: `grafana/dashboards/dora-metrics.json`
2. SLO & Error Budget Dashboard: `grafana/dashboards/slo-error-budget.json`
3. Node Exporter Dashboard: `grafana/dashboards/node-exporter.json`
4. Blackbox Exporter Dashboard: `grafana/dashboards/blackbox-exporter.json`
5. Unified Observability Dashboard: `grafana/dashboards/unified-observability.json`

### Unified Correlation (Non-negotiable)
- Error/latency spikes are visible in Prometheus panels.
- Loki logs are queryable in the same time window.
- Loki derived field extracts `trace_id` and links directly to Tempo.
- Tempo trace search identifies service and endpoint responsible.

## Four Golden Signals and SLIs
See: `docs/slo/four-golden-signals-sli.md`

- Latency: p95 of successful requests
- Traffic: request throughput
- Errors: 5xx ratio
- Saturation: CPU/memory/disk utilization ratios

## SLOs and Error Budgets
See:
- `docs/slo/slo-targets-and-error-budgets.md`
- `docs/slo/error-budget-policy.md`

Includes:
- SLO targets and rationale
- error budget formulas and thresholds
- burn-rate alert strategy
- policy actions at 50% and 100% budget consumption

## DORA and CI/CD Observability
See: `docs/dora/dora-metrics.md`

Includes:
- DF, LTC, CFR, MTTR definitions
- DORA benchmark classification logic
- CFR and MTTR alert thresholds
- identified toil and automation implemented

## Alerting System
- All alerts are in version-controlled YAML (`config/prometheus/alerts.yml`).
- Alertmanager routing/inhibition is defined in code (`config/alertmanager/alertmanager.yml`).
- Structured Slack payload template includes:
  - alert name
  - severity
  - affected host
  - metric value/context
  - Grafana link
  - runbook link
  - firing/resolved state

Silencing and inhibition guidance:
- `docs/alerting-routing-silencing.md`

## Runbooks and Incident Management
Runbooks (one per alert family):
- `runbooks/cpu.md`
- `runbooks/memory.md`
- `runbooks/disk.md`
- `runbooks/host-down.md`
- `runbooks/slo-fast-burn.md`
- `runbooks/slo-slow-burn.md`
- `runbooks/cfr.md`
- `runbooks/mttr.md`

PIR documents:
- Template: `docs/incident/pir-template.md`
- Example: `docs/incident/pir-example.md`

## Game Day Scenarios
Checklist and timeline template:
- `docs/gameday/scenarios.md`

Scenarios included:
1. Deployment failure
2. Latency injection
3. Resource pressure

## Why LGTM vs Managed Alternatives
- Full control over data flow, retention, and alert semantics
- Transparent cost profile and portability
- Deep customizability for SLI/SLO/error-budget models
- Strong cross-signal correlation (metrics/logs/traces) without vendor lock-in

## Notes
- Update placeholder runbook URLs (`github.com/your-org/...`) to your actual repository URL.
- Verify metric names from your chosen GitHub Actions exporter and adjust DORA queries if needed.
- For Linux host journal ingestion, ensure `/var/log/journal` is accessible to OTel Collector.
- Alert payload dashboard links can be set per-alert using the `dashboard` annotation; otherwise a default unified dashboard URL is used.
