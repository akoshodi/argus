#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <detected_unix_ts> <resolved_unix_ts>"
  exit 1
fi

detected="$1"
resolved="$2"

if [ "$resolved" -le "$detected" ]; then
  echo "resolved_unix_ts must be greater than detected_unix_ts"
  exit 1
fi

mttr_minutes=$(( (resolved - detected) / 60 ))
out_file="$(dirname "$0")/../metrics/incident.prom"

tmp_file="${out_file}.tmp"
cat > "$tmp_file" <<EOF
# HELP incident_mttr_minutes Mean time to restore in minutes.
# TYPE incident_mttr_minutes gauge
incident_mttr_minutes ${mttr_minutes}

# HELP incident_manual_intervention_minutes Portion of MTTR spent in manual intervention.
# TYPE incident_manual_intervention_minutes gauge
incident_manual_intervention_minutes 0

# HELP dora_ltc_commit_to_trigger_seconds Lead time sub-interval: commit to pipeline trigger.
# TYPE dora_ltc_commit_to_trigger_seconds gauge
dora_ltc_commit_to_trigger_seconds 0

# HELP dora_ltc_trigger_to_pipeline_complete_seconds Lead time sub-interval: trigger to pipeline complete.
# TYPE dora_ltc_trigger_to_pipeline_complete_seconds gauge
dora_ltc_trigger_to_pipeline_complete_seconds 0

# HELP dora_ltc_pipeline_complete_to_deploy_confirmed_seconds Lead time sub-interval: pipeline complete to deploy confirmed.
# TYPE dora_ltc_pipeline_complete_to_deploy_confirmed_seconds gauge
dora_ltc_pipeline_complete_to_deploy_confirmed_seconds 0

# HELP dora_ltc_total_seconds Total lead time for changes in seconds.
# TYPE dora_ltc_total_seconds gauge
dora_ltc_total_seconds 0
EOF

mv "$tmp_file" "$out_file"
echo "Updated incident_mttr_minutes=${mttr_minutes} in ${out_file}"
