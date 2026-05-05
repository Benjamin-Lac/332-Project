SELECT 
    c.Name AS Country,
    ci.Name AS Capital,
    e.Year,
    e.GDPGrowthPct,
    e.UnemploymentPct,
    e.InflationPct
FROM EconomicIndicator e
JOIN Country c ON e.CountryCode = c.Code
JOIN City ci ON c.Capital = ci.ID
ORDER BY c.Name, e.Year;