#JOIN: Official Languages and 2020 Economic Performance by Country
SELECT
    co.Name        AS Country,
    co.Continent,
    cl.Language    AS OfficialLanguage,
    cl.Percentage  AS SpokenByPct,
    ei.GDPGrowthPct,
    ei.InflationPct,
    ei.UnemploymentPct
FROM Country co
JOIN CountryLanguage cl ON co.Code = cl.CountryCode
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode
WHERE cl.IsOfficial = 'T'
  AND ei.Year = 2020
ORDER BY co.Name, cl.Percentage DESC;

# JOIN: UN Representatives, Their Country's Capital, and 2020 Health Infrastructure
SELECT
    un.FirstName,
    un.LastName,
    co.Name                  AS Country,
    co.Continent,
    ci.Name                  AS Capital,
    hs.HospitalBedsPer1000,
    hs.PhysiciansPer1000,
    hs.HealthExpPctGDP
FROM UN_Representative un
JOIN Country co ON un.CountryCode = co.Code
JOIN City ci ON co.Capital = ci.ID
JOIN HealthStats hs ON co.Code = hs.CountryCode
WHERE hs.Year = 2020
ORDER BY hs.HospitalBedsPer1000 DESC;