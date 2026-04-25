# Integration with CityPulse ETL

The CityPulse ETL project is responsible for ingestion, validation, cleaning, and loading of municipal service request records into PostgreSQL.

This warehouse project starts after that step.

## Upstream Contract

The warehouse expects the CityPulse ETL repo to create:

```text
public.service_requests
```

Required columns:

- unique_key
- created_date
- closed_date
- agency
- complaint_type
- descriptor
- borough
- status
- resolution_hours
- created_day
- created_hour
- is_closed
- priority_flag
- resolution_bucket

## Warehouse Import Step

The integration script maps the ETL table into the warehouse staging model:

```text
public.service_requests → staging.service_requests
```

This keeps the ETL output separate from dimensional modeling logic. If the ETL table changes later, only the integration mapping should need updates.

## Interview Explanation

A clean way to explain this project:

> CityPulse ETL creates the clean operational table. CityPulse Analytics Warehouse consumes that table and reorganizes it into dimensions, facts, and reporting marts so analysts can query trends without repeatedly cleaning or reshaping the raw records.
