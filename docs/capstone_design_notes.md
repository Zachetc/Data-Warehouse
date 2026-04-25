# Capstone Design Notes

This project is scoped as a compact analytics warehouse rather than a broad enterprise system.

## Design goals

1. Build on the CityPulse ETL pipeline instead of duplicating ingestion work.
2. Model cleaned records into a dimensional structure.
3. Preserve clear table grain and lineage.
4. Create reporting marts tied to realistic civic analytics questions.
5. Keep the implementation understandable enough to explain in an interview or capstone presentation.

## Tradeoffs

- PostgreSQL was chosen because it is accessible locally and supports schemas, materialized views, indexes, and constraints.
- SQL scripts were used instead of dbt or Airflow to keep the project explainable without adding orchestration complexity.
- The SCD2 implementation is a focused example rather than a full production change-data-capture system.
- Marts are intentionally limited to operational reporting questions rather than an exhaustive dashboard catalog.

## What I would improve next

The next version would add dbt models, dbt tests, a dashboard layer, and a scheduled refresh job.
