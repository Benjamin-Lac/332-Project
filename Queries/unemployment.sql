SELECT 
    ci.Name AS City,
    ci.District,
    ci.Population,
    co.Name AS Country
FROM City ci
JOIN Country co ON ci.CountryCode = co.Code
WHERE ci.CountryCode IN (
    SELECT DISTINCT CountryCode
    FROM EconomicIndicator
    WHERE UnemploymentPct > 10
)
ORDER BY ci.Population DESC
LIMIT 20;