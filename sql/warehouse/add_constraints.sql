-- Add explicit warehouse constraints after dimensions and facts are created.
-- The dimension and fact creation scripts already define primary keys.
-- This script adds foreign keys and performance indexes while remaining safe to rerun.

ALTER TABLE warehouse.fact_service_requests DROP CONSTRAINT IF EXISTS fk_fact_date;
ALTER TABLE warehouse.fact_service_requests DROP CONSTRAINT IF EXISTS fk_fact_location;
ALTER TABLE warehouse.fact_service_requests DROP CONSTRAINT IF EXISTS fk_fact_request_type;
ALTER TABLE warehouse.fact_service_requests DROP CONSTRAINT IF EXISTS fk_fact_status;

ALTER TABLE warehouse.fact_service_requests
    ADD CONSTRAINT fk_fact_date
    FOREIGN KEY (date_key) REFERENCES warehouse.dim_date(date_key);

ALTER TABLE warehouse.fact_service_requests
    ADD CONSTRAINT fk_fact_location
    FOREIGN KEY (location_key) REFERENCES warehouse.dim_location(location_key);

ALTER TABLE warehouse.fact_service_requests
    ADD CONSTRAINT fk_fact_request_type
    FOREIGN KEY (request_type_key) REFERENCES warehouse.dim_request_type(request_type_key);

ALTER TABLE warehouse.fact_service_requests
    ADD CONSTRAINT fk_fact_status
    FOREIGN KEY (status_key) REFERENCES warehouse.dim_status(status_key);

CREATE INDEX IF NOT EXISTS idx_fact_created_date ON warehouse.fact_service_requests(date_key);
CREATE INDEX IF NOT EXISTS idx_fact_location ON warehouse.fact_service_requests(location_key);
CREATE INDEX IF NOT EXISTS idx_fact_request_type ON warehouse.fact_service_requests(request_type_key);
CREATE INDEX IF NOT EXISTS idx_fact_status ON warehouse.fact_service_requests(status_key);
