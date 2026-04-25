# Incremental Load Strategy

The warehouse includes an incremental fact load example in:

```text
sql/incremental/load_fact_incremental.sql
```

## Strategy

The pipeline treats `request_id` as the natural event identifier. During incremental loads, a service request is inserted only if it does not already exist in `warehouse.fact_service_requests`.

```sql
WHERE NOT EXISTS (
    SELECT 1
    FROM warehouse.fact_service_requests f
    WHERE f.request_id = s.request_id
)
```

## Why this is useful

A full rebuild is simple for a small academic dataset, but an incremental load pattern is more realistic for operational systems because it avoids reprocessing all history every time the pipeline refreshes.

## Current limitation

This implementation handles new records. A more advanced version would also handle updates to existing open requests, such as a request moving from `Open` to `Closed`.
