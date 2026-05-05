SELECT 
    r.FirstName,
    r.LastName,
    c.Name AS Country,
    c.Continent,
    e.FDIInflowUSD
FROM UN_Representative r
JOIN Country c ON r.CountryCode = c.Code
JOIN EconomicIndicator e ON r.CountryCode = e.CountryCode
WHERE e.Year = 2010
  AND e.FDIInflowUSD > (
    SELECT AVG(FDIInflowUSD)
    FROM EconomicIndicator
    WHERE Year = 2010
)
ORDER BY e.FDIInflowUSD DESC;