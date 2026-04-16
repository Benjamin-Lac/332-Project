-- Sample data for added tables (relevant to world dataset)

INSERT INTO international_organization (organization_id, organization_name, founded_date, headquarters_country_code) VALUES
(1, 'United Nations', '1945-10-24', 'USA'),
(2, 'World Trade Organization', '1995-01-01', 'CHE'),
(3, 'European Union', '1993-11-01', 'BEL'),
(4, 'G20', '1999-09-26', 'SAU');

INSERT INTO country_organization_membership (membership_id, country_code, organization_id, joined_date, membership_status) VALUES
(1, 'USA', 1, '1945-10-24', 'Active'),
(2, 'CAN', 1, '1945-11-09', 'Active'),
(3, 'BRA', 1, '1945-10-24', 'Active'),
(4, 'IND', 1, '1945-10-30', 'Active'),
(5, 'JPN', 1, '1956-12-18', 'Active'),
(6, 'DEU', 3, '1993-11-01', 'Active'),
(7, 'FRA', 3, '1993-11-01', 'Active'),
(8, 'ITA', 3, '1993-11-01', 'Active'),
(9, 'MEX', 4, '1999-09-26', 'Active'),
(10, 'USA', 4, '1999-09-26', 'Active'),
(11, 'DEU', 4, '1999-09-26', 'Active'),
(12, 'ARG', 4, '1999-09-26', 'Active'),
(13, 'USA', 2, '1995-01-01', 'Active'),
(14, 'CAN', 2, '1995-01-01', 'Active'),
(15, 'BRA', 2, '1995-01-01', 'Active'),
(16, 'IND', 2, '1995-01-01', 'Active'),
(17, 'JPN', 2, '1995-01-01', 'Active'),
(18, 'MEX', 2, '1995-01-01', 'Active');

INSERT INTO country_gdp_history (country_code, record_year, gdp_usd_billion, gdp_growth_pct) VALUES
('USA', 2021, 23600.00, 5.70),
('USA', 2022, 25460.00, 2.10),
('CAN', 2021, 1990.00, 4.80),
('CAN', 2022, 2140.00, 3.40),
('MEX', 2021, 1310.00, 4.80),
('MEX', 2022, 1460.00, 3.90),
('BRA', 2021, 1600.00, 4.80),
('BRA', 2022, 1920.00, 2.90),
('DEU', 2021, 4250.00, 2.60),
('DEU', 2022, 4080.00, 1.80),
('FRA', 2021, 2950.00, 6.80),
('FRA', 2022, 2800.00, 2.50),
('IND', 2021, 3170.00, 8.90),
('IND', 2022, 3380.00, 6.80),
('JPN', 2021, 4940.00, 2.20),
('JPN', 2022, 4230.00, 1.00);

INSERT INTO climate_risk_assessment (country_code, risk_score, risk_level, assessed_on) VALUES
('USA', 41.20, 'Medium', '2024-06-01'),
('CAN', 33.80, 'Low', '2024-06-01'),
('MEX', 63.40, 'High', '2024-06-01'),
('BRA', 59.10, 'High', '2024-06-01'),
('DEU', 29.70, 'Low', '2024-06-01'),
('FRA', 31.20, 'Low', '2024-06-01'),
('IND', 72.40, 'High', '2024-06-01'),
('JPN', 54.00, 'Medium', '2024-06-01');
