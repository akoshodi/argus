# Four Golden Signals SLI Definitions

These SLIs are implemented as PromQL expressions and visualized in Grafana.

## 1) Latency
- SLI: p95 successful request latency over 5m
- PromQL:

```promql
histogram_quantile(
  0.95,
  sum(rate(http_server_request_duration_seconds_bucket{status!~"5.."}[5m])) by (le)
)
```

## 2) Traffic
- SLI: request throughput (requests/second)
- PromQL:

```promql
sum(rate(http_server_requests_total[5m]))
```

## 3) Errors
- SLI: error ratio (5xx / all requests)
- PromQL:

```promql
sum(rate(http_server_requests_total{status=~"5.."}[5m]))
/
sum(rate(http_server_requests_total[5m]))
```

## 4) Saturation
- SLI: CPU saturation ratio
- PromQL:

```promql
(100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)) / 100
```

- SLI: memory saturation ratio

```promql
1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)
```

- SLI: disk saturation ratio

```promql
1 - (
  node_filesystem_avail_bytes{fstype!~"tmpfs|overlay"}
  /
  node_filesystem_size_bytes{fstype!~"tmpfs|overlay"}
)
```
