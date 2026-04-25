# Grain Definition

The central fact table is `warehouse.fact_service_requests`.

## Fact table grain

The grain is:

> one row per service request event

This means every row represents a unique service request identified by `request_id`.

## Why grain matters

The warehouse supports request counts, backlog totals, response-time analysis, and priority workload reporting. Those metrics are only reliable if the fact table grain is consistent.

For example:

- `COUNT(*)` means total service requests
- `AVG(resolution_hours)` means average resolution time per request
- `SUM(priority_flag)` means priority request count
- monthly request volume aggregates from event-level request rows

## Dimension relationships

Each fact row connects to:

- `dim_date` through `date_key`
- `dim_location` through `location_key`
- `dim_request_type` through `request_type_key`
- `dim_status` through `status_key`

The dimensions provide descriptive context while the fact table stores measurable service request events.
