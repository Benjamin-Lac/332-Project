-- CPSC 332 Final Project - Alan Leyva
-- JOIN: Countries with their capital city and UN Representative
use world;
SELECT co.name AS Country, ci.name AS CapitalCity,
	un.FirstName, un.LastName, un.AppointDate
FROM Country co
JOIN city ci ON co.Capital = ci.ID
JOIN UN_REPRESENTATIVE un ON co.Code = un.CountryCode;

-- SUBQUERY: Countries with official language spoken by 80%+ of population and their health stats
SELECT co.Name AS Country, co.Continent,
       (SELECT cl.Language FROM CountryLanguage cl 
        WHERE cl.CountryCode = co.Code AND cl.IsOfficial = 'T' 
        AND cl.Percentage >= 80 LIMIT 1) AS DominantLanguage,
       (SELECT hs.AccessToWaterPct FROM HealthStats hs 
        WHERE hs.CountryCode = co.Code AND hs.Year = 2020) AS AccessToWaterPct,
       (SELECT hs.InfantMortalityRate FROM HealthStats hs 
        WHERE hs.CountryCode = co.Code AND hs.Year = 2020) AS InfantMortalityRate
FROM Country co
WHERE co.Code IN (SELECT cl.CountryCode FROM CountryLanguage cl 
                  WHERE cl.IsOfficial = 'T' AND cl.Percentage >= 80)
  AND co.Code IN (SELECT hs.CountryCode FROM HealthStats hs WHERE hs.Year = 2020);
  
  -- SUBQUERY: Countries with UN reps that have above average water access
SELECT co.Name AS Country, co.Continent,
       (SELECT CONCAT(un.FirstName, ' ', un.LastName) FROM UN_Representative un 
        WHERE un.CountryCode = co.Code LIMIT 1) AS UNRep,
       (SELECT hs.AccessToWaterPct FROM HealthStats hs 
        WHERE hs.CountryCode = co.Code AND hs.Year = 2020) AS AccessToWaterPct
FROM Country co
WHERE co.Code IN (SELECT un.CountryCode FROM UN_Representative un)
  AND (SELECT hs.AccessToWaterPct FROM HealthStats hs 
       WHERE hs.CountryCode = co.Code AND hs.Year = 2020) > 
      (SELECT AVG(hs2.AccessToWaterPct) FROM HealthStats hs2 WHERE hs2.Year = 2020);
      
-- SUBQUERY: Cities in countries that had positive GDP growth in 2020
SELECT ci.Name AS City, ci.District, ci.Population,
       co.Name AS Country,
       (SELECT ei.GDPGrowthPct FROM EconomicIndicator ei 
        WHERE ei.CountryCode = co.Code AND ei.Year = 2020) AS GDPGrowth2020
FROM City ci
JOIN Country co ON ci.CountryCode = co.Code
WHERE co.Code IN (SELECT ei.CountryCode FROM EconomicIndicator ei 
                  WHERE ei.Year = 2020 AND ei.GDPGrowthPct > 0)
ORDER BY GDPGrowth2020 DESC;

-- SUBQUERY: Countries with UN representatives that have declining unemployment from 2000 to 2020
SELECT co.Name AS Country, co.Continent,
       (SELECT CONCAT(un.FirstName, ' ', un.LastName) FROM UN_Representative un
        WHERE un.CountryCode = co.Code LIMIT 1) AS UNRep,
       (SELECT ei.UnemploymentPct FROM EconomicIndicator ei
        WHERE ei.CountryCode = co.Code AND ei.Year = 2000) AS Unemployment2000,
       (SELECT ei.UnemploymentPct FROM EconomicIndicator ei
        WHERE ei.CountryCode = co.Code AND ei.Year = 2020) AS Unemployment2020
FROM Country co
WHERE co.Code IN (SELECT un.CountryCode FROM UN_Representative un)
  AND (SELECT ei.UnemploymentPct FROM EconomicIndicator ei
       WHERE ei.CountryCode = co.Code AND ei.Year = 2020) <
      (SELECT ei.UnemploymentPct FROM EconomicIndicator ei
       WHERE ei.CountryCode = co.Code AND ei.Year = 2000)
ORDER BY Unemployment2020 ASC;