# Error Budget Policy

## Ownership
- Service Owner: API team lead.
- Reliability Gatekeeper: Platform/DevOps lead.
- Final arbitration: Engineering manager.

## Threshold Actions
- 0-50% consumed:
  - Normal delivery allowed.
  - Keep reliability backlog prioritized.
- 50-100% consumed:
  - Feature development slows down.
  - At least 30% sprint capacity reserved for reliability work.
  - Mandatory risk review before each deployment.
- 100% consumed:
  - Feature freeze for affected service.
  - Reliability sprint starts immediately.
  - Only fixes improving reliability can be deployed.

## Decision Cadence
- Burn-rate alerts: handled in real time via #DevOps-Alerts.
- Weekly SLO review meeting: action tracking and risk assessment.
- Monthly policy review: target updates and learning incorporation.

## Exception Process
- Critical business release can bypass freeze only with written approval from EM + Platform Lead + Product Lead.
- Post-release corrective plan must be committed within 24 hours.
