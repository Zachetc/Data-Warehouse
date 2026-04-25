INSERT INTO raw.service_requests (request_id, created_at, closed_at, agency, request_type, descriptor, status, borough, neighborhood, latitude, longitude, source_file) VALUES
('REQ-1001', '2026-01-03 08:15:00', '2026-01-04 10:30:00', 'DEP', 'Noise Complaint', 'Loud Music', 'Closed', 'Queens', 'Astoria', 40.7644, -73.9235, 'sample'),
('REQ-1002', '2026-01-05 14:20:00', NULL, 'HPD', 'Heat Complaint', 'No Heat', 'Open', 'Bronx', 'Fordham', 40.8620, -73.8910, 'sample'),
('REQ-1003', '2026-01-07 09:00:00', '2026-01-07 18:45:00', 'DSNY', 'Sanitation Complaint', 'Missed Collection', 'Closed', 'Brooklyn', 'Bushwick', 40.6958, -73.9171, 'sample');
