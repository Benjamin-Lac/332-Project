SELECT 
    r.FirstName,
    r.LastName,
    r.CountryCode,
    r.AppointDate
FROM UN_Representative r
WHERE r.CountryCode IN (
    SELECT e.CountryCode
    FROM EconomicIndicator e
    WHERE e.Year = 2020 AND e.GDPGrowthPct < 0
);