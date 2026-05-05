SELECT 
    c.Name AS Country,
    c.Continent,
    cl.Language AS OfficialLanguage,
    h.InfantMortalityRate,
    h.HealthExpPctGDP,
    h.AccessToWaterPct
FROM HealthStats h
JOIN Country c ON h.CountryCode = c.Code
JOIN CountryLanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T'
ORDER BY h.InfantMortalityRate DESC;