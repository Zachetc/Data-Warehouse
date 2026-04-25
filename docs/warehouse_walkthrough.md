# Warehouse Walkthrough

This warehouse extends the CityPulse ETL project by converting cleaned service request records into a dimensional analytics model.

## Layer 1: CityPulse ETL Output

The upstream ETL pipeline loads cleaned records into:

```text
public.service_requests
```

This table is treated as the operational cleaned source.

## Layer 2: Staging

`sql/integration/import_from_citypulse_etl.sql` copies and renames fields into:

```text
staging.service_requests
```

The staging layer creates a stable contract for downstream SQL.

## Layer 3: Dimensions

The warehouse creates reusable lookup tables for date, location, request type, and status.

## Layer 4: Fact Table

`warehouse.fact_service_requests` stores one row per request with numeric measures such as request count and resolution hours.

## Layer 5: Marts

The mart layer exposes ready-to-query views for monthly volume, category workload, borough performance, and operational KPIs.

## Why this matters

Separating ETL from warehousing makes the system easier to explain and maintain. The ETL project handles data cleanup; the warehouse project handles analytical modeling.
