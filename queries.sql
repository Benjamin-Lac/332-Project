-- ============================================================
-- CPSC 332 - World Database: 20 Queries
-- Spring 2026
-- Queries 1-10: JOIN-based | Queries 11-20: Subquery-based
-- All queries use base tables + additional tables
-- ============================================================

USE world;

-- ============================================================
-- JOIN QUERIES (1-10)
-- ============================================================

-- Query 1
-- PURPOSE: Identify countries where the UN representative has served
-- for over 3 years, alongside the country's current GNP.
-- VALUE: Helps the UN assess diplomatic continuity and economic context.
SELECT
    co.Name                                     AS Country,
    CONCAT(r.FirstName, ' ', r.LastName)        AS Representative,
    r.AppointDate,
    TIMESTAMPDIFF(YEAR, r.AppointDate, CURDATE()) AS YearsServed,
    co.GNP
FROM Country co
JOIN UN_Representative r ON co.Code = r.CountryCode
WHERE TIMESTAMPDIFF(YEAR, r.AppointDate, CURDATE()) > 3
ORDER BY YearsServed DESC;


-- Query 2
-- PURPOSE: Show the most populous city in each country along with
-- that country's life expectancy and health expenditure % of GDP.
-- VALUE: Reveals whether large urban populations correlate with
-- better health investment.
SELECT
    co.Name                 AS Country,
    ci.Name                 AS LargestCity,
    ci.Population           AS CityPopulation,
    co.LifeExpectancy,
    hs.HealthExpPctGDP
FROM Country co
JOIN City ci ON co.Code = ci.CountryCode
JOIN HealthStats hs ON co.Code = hs.CountryCode
WHERE ci.Population = (
    SELECT MAX(c2.Population)
    FROM City c2
    WHERE c2.CountryCode = co.Code
)
AND hs.Year = 2020
ORDER BY ci.Population DESC
LIMIT 15;


-- Query 3
-- PURPOSE: Compare GDP growth rates with unemployment rates per country
-- in the year 2020, alongside continent information.
-- VALUE: Useful for understanding how the COVID-19 pandemic affected
-- different global regions economically.
SELECT
    co.Name         AS Country,
    co.Continent,
    co.Region,
    ei.Year,
    ei.GDPGrowthPct,
    ei.UnemploymentPct,
    ei.InflationPct
FROM Country co
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode
WHERE ei.Year = 2020
ORDER BY ei.GDPGrowthPct ASC;


-- Query 4
-- PURPOSE: List all official languages spoken in countries whose UN
-- representative was appointed after 2020, joined with population data.
-- VALUE: Helps the UN plan multilingual communication strategies for
-- newly appointed representatives.
SELECT
    co.Name                                  AS Country,
    cl.Language,
    cl.IsOfficial,
    cl.Percentage,
    co.Population,
    CONCAT(r.FirstName, ' ', r.LastName)     AS Representative,
    r.AppointDate
FROM Country co
JOIN CountryLanguage cl ON co.Code = cl.CountryCode
JOIN UN_Representative r ON co.Code = r.CountryCode
WHERE cl.IsOfficial = 'T'
  AND r.AppointDate > '2020-01-01'
ORDER BY co.Name, cl.Percentage DESC;


-- Query 5
-- PURPOSE: Rank continents by average infant mortality rate (2020)
-- and average physician density, with country counts.
-- VALUE: Identifies which continents need the most medical infrastructure
-- investment from the UN.
SELECT
    co.Continent,
    COUNT(DISTINCT co.Code)             AS CountryCount,
    ROUND(AVG(hs.InfantMortalityRate), 2) AS AvgInfantMortality,
    ROUND(AVG(hs.PhysiciansPer1000), 2)   AS AvgPhysiciansPer1000,
    ROUND(AVG(hs.AccessToWaterPct), 2)    AS AvgWaterAccess,
    ROUND(AVG(hs.HealthExpPctGDP), 2)     AS AvgHealthExpPctGDP
FROM Country co
JOIN HealthStats hs ON co.Code = hs.CountryCode
WHERE hs.Year = 2020
GROUP BY co.Continent
ORDER BY AvgInfantMortality DESC;


-- Query 6
-- PURPOSE: Find countries with a negative trade balance (imports > exports)
-- in 2020 and show their city counts and total urban population.
-- VALUE: Exposes countries with trade deficits that may need UN economic aid.
SELECT
    co.Name                         AS Country,
    co.Continent,
    ei.TradeBalanceUSD,
    COUNT(ci.ID)                    AS NumberOfCities,
    SUM(ci.Population)              AS TotalUrbanPopulation,
    co.Population                   AS TotalPopulation
FROM Country co
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode
JOIN City ci ON co.Code = ci.CountryCode
WHERE ei.Year = 2020
  AND ei.TradeBalanceUSD < 0
GROUP BY co.Code, co.Name, co.Continent, ei.TradeBalanceUSD, co.Population
ORDER BY ei.TradeBalanceUSD ASC;


-- Query 7
-- PURPOSE: Display countries where life expectancy exceeds 75 years
-- alongside their unemployment rate and FDI inflows (2010).
-- VALUE: Examines whether high-quality-of-life countries attract
-- more foreign investment.
SELECT
    co.Name             AS Country,
    co.LifeExpectancy,
    ei.UnemploymentPct,
    ei.FDIInflowUSD,
    ei.GDPGrowthPct
FROM Country co
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode
WHERE co.LifeExpectancy > 75
  AND ei.Year = 2010
ORDER BY ei.FDIInflowUSD DESC;


-- Query 8
-- PURPOSE: Show the number of cities per district in a given country
-- (using Brazil as example) joined with that country's health stats.
-- VALUE: Urban planning and health resource distribution analysis.
SELECT
    ci.District,
    COUNT(ci.ID)                    AS CityCount,
    SUM(ci.Population)              AS DistrictUrbanPop,
    ROUND(AVG(ci.Population), 0)    AS AvgCityPop,
    hs.PhysiciansPer1000,
    hs.HospitalBedsPer1000
FROM City ci
JOIN Country co ON ci.CountryCode = co.Code
JOIN HealthStats hs ON co.Code = hs.CountryCode
WHERE co.Code = 'BRA'
  AND hs.Year = 2020
GROUP BY ci.District, hs.PhysiciansPer1000, hs.HospitalBedsPer1000
HAVING CityCount > 1
ORDER BY DistrictUrbanPop DESC;


-- Query 9
-- PURPOSE: Join all five tables to create a comprehensive profile of
-- countries with active UN representatives, showing economic and
-- health indicators side-by-side.
-- VALUE: Provides a 360-degree snapshot for UN policy briefings.
SELECT
    co.Name                                         AS Country,
    co.Continent,
    CONCAT(r.FirstName, ' ', r.LastName)            AS UNRep,
    ei.GDPGrowthPct,
    ei.InflationPct,
    hs.LifeExpectancy_Approx,
    hs.InfantMortalityRate,
    hs.AccessToWaterPct,
    (SELECT COUNT(*) FROM City ci WHERE ci.CountryCode = co.Code) AS CityCount
FROM Country co
JOIN UN_Representative r  ON co.Code = r.CountryCode
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode AND ei.Year = 2020
JOIN (
    SELECT CountryCode,
           InfantMortalityRate,
           AccessToWaterPct,
           HealthExpPctGDP,
           co2.LifeExpectancy AS LifeExpectancy_Approx
    FROM HealthStats hs2
    JOIN Country co2 ON hs2.CountryCode = co2.Code
    WHERE hs2.Year = 2020
) hs ON co.Code = hs.CountryCode
ORDER BY ei.GDPGrowthPct DESC;


-- Query 10
-- PURPOSE: Identify the top 5 most-spoken official languages across
-- countries that had positive GDP growth in 2020, with speaker estimates.
-- VALUE: Shows which languages dominate economically resilient nations.
SELECT
    cl.Language,
    COUNT(DISTINCT co.Code)                         AS CountriesUsing,
    SUM(co.Population * cl.Percentage / 100)        AS EstimatedSpeakers,
    ROUND(AVG(ei.GDPGrowthPct), 2)                  AS AvgGDPGrowth2020,
    ROUND(AVG(co.LifeExpectancy), 1)                AS AvgLifeExpectancy
FROM CountryLanguage cl
JOIN Country co ON cl.CountryCode = co.Code
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode
WHERE cl.IsOfficial = 'T'
  AND ei.Year = 2020
  AND ei.GDPGrowthPct > 0
GROUP BY cl.Language
ORDER BY EstimatedSpeakers DESC
LIMIT 10;


-- ============================================================
-- SUBQUERY QUERIES (11-20)
-- ============================================================

-- Query 11
-- PURPOSE: Find countries whose GNP is above the world average AND
-- whose infant mortality in 2020 is below the global average.
-- VALUE: Identifies wealthy, healthy nations — potential donors
-- for UN development programs.
SELECT
    co.Name,
    co.GNP,
    co.LifeExpectancy,
    hs.InfantMortalityRate,
    hs.AccessToWaterPct
FROM Country co
JOIN HealthStats hs ON co.Code = hs.CountryCode
WHERE co.GNP > (
        SELECT AVG(GNP) FROM Country WHERE GNP IS NOT NULL AND GNP > 0
    )
  AND hs.InfantMortalityRate < (
        SELECT AVG(InfantMortalityRate) FROM HealthStats WHERE Year = 2020
    )
  AND hs.Year = 2020
ORDER BY co.GNP DESC;


-- Query 12
-- PURPOSE: List countries whose unemployment rate in 2020 was worse
-- than the average unemployment of their own continent.
-- VALUE: Flags underperforming economies within each regional bloc
-- for targeted UN intervention.
SELECT
    co.Name,
    co.Continent,
    ei.UnemploymentPct,
    (
        SELECT ROUND(AVG(ei2.UnemploymentPct), 2)
        FROM EconomicIndicator ei2
        JOIN Country co2 ON ei2.CountryCode = co2.Code
        WHERE co2.Continent = co.Continent
          AND ei2.Year = 2020
    ) AS ContinentAvgUnemployment
FROM Country co
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode
WHERE ei.Year = 2020
  AND ei.UnemploymentPct > (
        SELECT AVG(ei3.UnemploymentPct)
        FROM EconomicIndicator ei3
        JOIN Country co3 ON ei3.CountryCode = co3.Code
        WHERE co3.Continent = co.Continent
          AND ei3.Year = 2020
    )
ORDER BY co.Continent, ei.UnemploymentPct DESC;


-- Query 13
-- PURPOSE: Find all cities located in countries that have a UN
-- representative currently serving (no end date), with city population
-- over 1 million.
-- VALUE: Maps major urban centers in diplomatically active nations.
SELECT
    ci.Name         AS City,
    ci.Population,
    ci.District,
    co.Name         AS Country,
    co.Continent
FROM City ci
JOIN Country co ON ci.CountryCode = co.Code
WHERE ci.Population > 1000000
  AND co.Code IN (
        SELECT CountryCode
        FROM UN_Representative
        WHERE TermEndDate IS NULL
    )
ORDER BY ci.Population DESC;


-- Query 14
-- PURPOSE: Show countries where health expenditure as % of GDP grew
-- between 2000 and 2020, ranked by improvement.
-- VALUE: Tracks which nations are increasingly prioritizing healthcare
-- over time — key for UN health program partnerships.
SELECT
    co.Name,
    co.Continent,
    hs2000.HealthExpPctGDP  AS HealthExp2000,
    hs2020.HealthExpPctGDP  AS HealthExp2020,
    ROUND(hs2020.HealthExpPctGDP - hs2000.HealthExpPctGDP, 2) AS Improvement
FROM Country co
JOIN HealthStats hs2000 ON co.Code = hs2000.CountryCode AND hs2000.Year = 2000
JOIN HealthStats hs2020 ON co.Code = hs2020.CountryCode AND hs2020.Year = 2020
WHERE hs2020.HealthExpPctGDP > hs2000.HealthExpPctGDP
  AND co.Code IN (
        SELECT DISTINCT CountryCode FROM EconomicIndicator
    )
ORDER BY Improvement DESC;


-- Query 15
-- PURPOSE: Find languages spoken in countries where the population is
-- larger than the average population of countries on the same continent.
-- VALUE: Identifies dominant languages in the most populous nations
-- per region for UN communications planning.
SELECT DISTINCT
    cl.Language,
    co.Name     AS Country,
    co.Population,
    co.Continent,
    cl.IsOfficial
FROM CountryLanguage cl
JOIN Country co ON cl.CountryCode = co.Code
WHERE co.Population > (
        SELECT AVG(co2.Population)
        FROM Country co2
        WHERE co2.Continent = co.Continent
    )
  AND cl.IsOfficial = 'T'
ORDER BY co.Continent, co.Population DESC;


-- Query 16
-- PURPOSE: Identify countries that had negative GDP growth in BOTH
-- 2010 and 2020 (double-dip economic decline).
-- VALUE: Pinpoints chronically struggling economies needing sustained
-- UN economic support.
SELECT
    co.Name,
    co.Continent,
    co.GNP,
    co.LifeExpectancy,
    ei2010.GDPGrowthPct AS GDPGrowth2010,
    ei2020.GDPGrowthPct AS GDPGrowth2020
FROM Country co
JOIN EconomicIndicator ei2010 ON co.Code = ei2010.CountryCode AND ei2010.Year = 2010
JOIN EconomicIndicator ei2020 ON co.Code = ei2020.CountryCode AND ei2020.Year = 2020
WHERE co.Code IN (
        SELECT ei_a.CountryCode
        FROM EconomicIndicator ei_a
        WHERE ei_a.Year = 2010 AND ei_a.GDPGrowthPct < 0
    )
  AND co.Code IN (
        SELECT ei_b.CountryCode
        FROM EconomicIndicator ei_b
        WHERE ei_b.Year = 2020 AND ei_b.GDPGrowthPct < 0
    )
ORDER BY ei2020.GDPGrowthPct ASC;


-- Query 17
-- PURPOSE: Return countries where access to clean water in 2020 is
-- below 80%, grouped by continent with average infant mortality.
-- VALUE: Targets water-insecure nations for UN humanitarian programs.
SELECT
    co.Name,
    co.Continent,
    hs.AccessToWaterPct,
    hs.InfantMortalityRate,
    hs.PhysiciansPer1000,
    (
        SELECT ROUND(AVG(hs2.InfantMortalityRate), 2)
        FROM HealthStats hs2
        JOIN Country co2 ON hs2.CountryCode = co2.Code
        WHERE co2.Continent = co.Continent
          AND hs2.Year = 2020
    ) AS ContinentAvgInfantMort
FROM Country co
JOIN HealthStats hs ON co.Code = hs.CountryCode
WHERE hs.Year = 2020
  AND hs.AccessToWaterPct < 80
  AND co.Code NOT IN (
        SELECT CountryCode FROM UN_Representative WHERE TermEndDate IS NULL
    )
ORDER BY hs.AccessToWaterPct ASC;


-- Query 18
-- PURPOSE: Find countries with more cities than the average number of
-- cities per country, showing their economic and health profile.
-- VALUE: Assesses whether highly urbanized nations have proportional
-- health and economic development.
SELECT
    co.Name,
    co.Continent,
    (SELECT COUNT(*) FROM City ci WHERE ci.CountryCode = co.Code) AS CityCount,
    ei.GDPGrowthPct,
    ei.UnemploymentPct,
    hs.InfantMortalityRate,
    hs.HealthExpPctGDP
FROM Country co
JOIN EconomicIndicator ei ON co.Code = ei.CountryCode AND ei.Year = 2020
JOIN HealthStats hs       ON co.Code = hs.CountryCode AND hs.Year = 2020
WHERE (
        SELECT COUNT(*) FROM City ci WHERE ci.CountryCode = co.Code
    ) > (
        SELECT AVG(city_count)
        FROM (
            SELECT COUNT(*) AS city_count
            FROM City
            GROUP BY CountryCode
        ) AS counts
    )
ORDER BY CityCount DESC;


-- Query 19
-- PURPOSE: Show countries where the inflation rate improved (decreased)
-- between 2000 and 2020, alongside their UN representative and GNP rank.
-- VALUE: Recognizes nations with strong monetary policy progress —
-- candidates for UN economic best-practice showcases.
SELECT
    co.Name,
    co.GNP,
    ei2000.InflationPct     AS Inflation2000,
    ei2020.InflationPct     AS Inflation2020,
    ROUND(ei2000.InflationPct - ei2020.InflationPct, 2) AS InflationReduction,
    (
        SELECT CONCAT(r.FirstName, ' ', r.LastName)
        FROM UN_Representative r
        WHERE r.CountryCode = co.Code
          AND r.TermEndDate IS NULL
        LIMIT 1
    ) AS CurrentUNRep
FROM Country co
JOIN EconomicIndicator ei2000 ON co.Code = ei2000.CountryCode AND ei2000.Year = 2000
JOIN EconomicIndicator ei2020 ON co.Code = ei2020.CountryCode AND ei2020.Year = 2020
WHERE ei2020.InflationPct < ei2000.InflationPct
ORDER BY InflationReduction DESC;


-- Query 20
-- PURPOSE: Identify countries where both life expectancy is above 70
-- AND physician density per 1000 is below the global average (2020),
-- revealing healthcare access gaps in otherwise healthy populations.
-- VALUE: Targets countries for UN physician and health worker programs.
SELECT
    co.Name,
    co.Continent,
    co.LifeExpectancy,
    hs.PhysiciansPer1000,
    hs.HospitalBedsPer1000,
    hs.InfantMortalityRate,
    (
        SELECT ROUND(AVG(hs3.PhysiciansPer1000), 2)
        FROM HealthStats hs3
        WHERE hs3.Year = 2020
    ) AS GlobalAvgPhysicians
FROM Country co
JOIN HealthStats hs ON co.Code = hs.CountryCode
WHERE co.LifeExpectancy > 70
  AND hs.Year = 2020
  AND hs.PhysiciansPer1000 < (
        SELECT AVG(hs2.PhysiciansPer1000)
        FROM HealthStats hs2
        WHERE hs2.Year = 2020
    )
ORDER BY hs.PhysiciansPer1000 ASC;
