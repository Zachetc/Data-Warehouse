# Data Dictionary

## warehouse.fact_service_requests

- request_id: unique service request identifier
- created_date_key: foreign key to dim_date
- location_key: foreign key to dim_location
- request_type_key: foreign key to dim_request_type
- status_key: foreign key to dim_status
- resolution_hours: time between creation and closure
- is_open: unresolved request flag
- is_priority_request: high-priority service type flag
- request_count: additive measure for aggregation
