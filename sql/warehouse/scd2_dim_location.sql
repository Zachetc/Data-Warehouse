-- SCD Type 2 example for dim_location.
-- This is included to show how a warehouse could preserve historical changes
-- in location attributes such as borough grouping or service zone assignment.

ALTER TABLE warehouse.dim_location
    ADD COLUMN IF NOT EXISTS service_zone TEXT,
    ADD COLUMN IF NOT EXISTS valid_from DATE DEFAULT CURRENT_DATE,
    ADD COLUMN IF NOT EXISTS valid_to DATE,
    ADD COLUMN IF NOT EXISTS is_current BOOLEAN DEFAULT TRUE;

-- Example pattern: expire the current record when a location attribute changes.
-- This is intentionally written as a template because the sample dataset does not
-- contain changing service zones yet.

-- UPDATE warehouse.dim_location
-- SET valid_to = CURRENT_DATE - INTERVAL '1 day',
--     is_current = FALSE
-- WHERE borough = 'Queens'
--   AND service_zone = 'North'
--   AND is_current = TRUE;

-- INSERT INTO warehouse.dim_location (
--     borough,
--     neighborhood,
--     service_zone,
--     valid_from,
--     valid_to,
--     is_current
-- )
-- VALUES ('Queens', 'Astoria', 'West', CURRENT_DATE, NULL, TRUE);
