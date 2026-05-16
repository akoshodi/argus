#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "usage: $0 <commit_to_trigger_s> <trigger_to_complete_s> <complete_to_confirmed_s>"
  exit 1
fi

c2t="$1"
t2c="$2"
c2d="$3"

for value in "$c2t" "$t2c" "$c2d"; do
  if [ "$value" -lt 0 ]; then
    echo "all values must be non-negative"
    exit 1
  fi
done

total=$(( c2t + t2c + c2d ))
out_file="$(dirname "$0")/../metrics/incident.prom"

current_mttr=0
current_manual=0
if [ -f "$out_file" ]; then
  current_mttr=$(awk '/^incident_mttr_minutes / {print $2}' "$out_file" | tail -n1)
  current_manual=$(awk '/^incident_manual_intervention_minutes / {print $2}' "$out_file" | tail -n1)
fi

: "${current_mttr:=0}"
: "${current_manual:=0}"

tmp_file="${out_file}.tmp"
cat > "$tmp_file" <<EOF
# HELP incident_mttr_minutes Mean time to restore in minutes.
# TYPE incident_mttr_minutes gauge
incident_mttr_minutes ${current_mttr}

# HELP incident_manual_intervention_minutes Portion of MTTR spent in manual intervention.
# TYPE incident_manual_intervention_minutes gauge
incident_manual_intervention_minutes ${current_manual}

# HELP dora_ltc_commit_to_trigger_seconds Lead time sub-interval: commit to pipeline trigger.
# TYPE dora_ltc_commit_to_trigger_seconds gauge
dora_ltc_commit_to_trigger_seconds ${c2t}

# HELP dora_ltc_trigger_to_pipeline_complete_seconds Lead time sub-interval: trigger to pipeline complete.
# TYPE dora_ltc_trigger_to_pipeline_complete_seconds gauge
dora_ltc_trigger_to_pipeline_complete_seconds ${t2c}

# HELP dora_ltc_pipeline_complete_to_deploy_confirmed_seconds Lead time sub-interval: pipeline complete to deploy confirmed.
# TYPE dora_ltc_pipeline_complete_to_deploy_confirmed_seconds gauge
dora_ltc_pipeline_complete_to_deploy_confirmed_seconds ${c2d}

# HELP dora_ltc_total_seconds Total lead time for changes in seconds.
# TYPE dora_ltc_total_seconds gauge
dora_ltc_total_seconds ${total}
EOF

mv "$tmp_file" "$out_file"
echo "Updated LTC metrics in ${out_file}"
