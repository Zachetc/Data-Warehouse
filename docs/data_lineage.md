# Data Lineage

CityPulse Analytics Warehouse is designed as a downstream system for the CityPulse ETL pipeline.

## Source-to-mart lineage

```text
CityPulse ETL
  public.service_requests
        ↓
staging.service_requests
        ↓
warehouse.dim_date
warehouse.dim_location
warehouse.dim_request_type
warehouse.dim_status
        ↓
warehouse.fact_service_requests
        ↓
marts.request_volume_monthly
marts.response_time_distribution
marts.priority_request_trends
marts.open_request_backlog
```

## Responsibility by layer

| Layer | Responsibility |
|---|---|
| CityPulse ETL | Ingests, cleans, validates source data |
| Staging | Copies cleaned ETL output into a warehouse-controlled schema |
| Warehouse | Builds dimensions and fact tables with keys and relationships |
| Marts | Exposes simplified tables for dashboards and analyst queries |
| Quality | Checks duplicate IDs, missing timestamps, orphaned keys, and invalid metrics |

## Why this matters

Separating layers makes the pipeline easier to debug. If a metric looks wrong, the issue can be traced to a specific layer rather than searching through one large script.
