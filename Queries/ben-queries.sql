-- CPSC 332 Final Project
USE world;

/*
    Query 1

    SUBQUERY QUERY

    Population Density vs Development Indicators (2020)

    Computes each country's population density (people per km²) using
    Country.SurfaceArea — a column untouched by all other queries.
    Scalar correlated subqueries pull in GDP growth, unemployment, water access,
    and physician density for each country. The WHERE clause uses IN subqueries
    to restrict results to countries that have both economic and health data for 2020.
    Helps the UN identify where overcrowding strains public services.
*/
SELECT
    co.Name                                                         AS Country,
    co.Continent,
    co.Population,
    co.SurfaceArea,
    ROUND(co.Population / co.SurfaceArea, 2)                       AS PopDensityPerKm2,
    (SELECT ei.GDPGrowthPct
     FROM EconomicIndicator ei
     WHERE ei.CountryCode = co.Code AND ei.Year = 2020)            AS GDPGrowthPct,
    (SELECT ei.UnemploymentPct
     FROM EconomicIndicator ei
     WHERE ei.CountryCode = co.Code AND ei.Year = 2020)            AS UnemploymentPct,
    (SELECT hs.AccessToWaterPct
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2020)            AS AccessToWaterPct,
    (SELECT hs.PhysiciansPer1000
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2020)            AS PhysiciansPer1000
FROM Country co
WHERE co.SurfaceArea > 0
  AND co.Population IS NOT NULL
  AND co.Code IN (SELECT CountryCode FROM EconomicIndicator WHERE Year = 2020)
  AND co.Code IN (SELECT CountryCode FROM HealthStats WHERE Year = 2020)
ORDER BY PopDensityPerKm2 DESC;


/*
    Query 2

    SUBQUERY QUERY

    Historical GNP Growth Rate with Current UN Representation and Health Stats

    Uses Country.GNPOld (the prior-period GNP snapshot) alongside Country.GNP
    to compute a GNP growth percentage — a column pair no other query touches.
    Scalar correlated subqueries retrieve the UN representative name, appointment
    date, health expenditure, and hospital beds for each country without any
    explicit JOINs. The WHERE clause restricts to countries that appear in both
    UN_Representative and HealthStats.
*/
SELECT
    co.Name                                                         AS Country,
    co.Continent,
    co.GNP,
    co.GNPOld,
    ROUND(co.GNP - co.GNPOld, 2)                                   AS GNPChange,
    ROUND((co.GNP - co.GNPOld) / NULLIF(co.GNPOld, 0) * 100, 2)  AS GNPGrowthPct,
    (SELECT CONCAT(r.FirstName, ' ', r.LastName)
     FROM UN_Representative r
     WHERE r.CountryCode = co.Code AND r.TermEndDate IS NULL)       AS UNRepresentative,
    (SELECT MAX(r.AppointDate)
     FROM UN_Representative r
     WHERE r.CountryCode = co.Code)                                 AS AppointDate,
    (SELECT hs.HealthExpPctGDP
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2020)            AS HealthExpPctGDP,
    (SELECT hs.HospitalBedsPer1000
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2020)            AS HospitalBedsPer1000
FROM Country co
WHERE co.GNP    IS NOT NULL
  AND co.GNPOld IS NOT NULL
  AND co.Code IN (SELECT CountryCode FROM UN_Representative)
  AND co.Code IN (SELECT CountryCode FROM HealthStats WHERE Year = 2020)
ORDER BY GNPGrowthPct DESC;


/*
    Query 3

    SUBQUERY QUERY

    Countries That Reduced Infant Mortality by More Than 50% Since 2000

    Scalar correlated subqueries retrieve the 2000 and 2020 infant mortality
    figures for each country directly in the SELECT list. A correlated subquery
    in the WHERE clause filters to only countries where the 2020 rate is less
    than half of their own 2000 rate — a dramatic health improvement milestone.
    A further scalar subquery surfaces the current UN representative inline.
*/
SELECT
    co.Name                                                         AS Country,
    co.Continent,
    (SELECT hs.InfantMortalityRate
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2000)            AS InfantMort2000,
    (SELECT hs.InfantMortalityRate
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2020)            AS InfantMort2020,
    ROUND(
        (SELECT hs.InfantMortalityRate
         FROM HealthStats hs
         WHERE hs.CountryCode = co.Code AND hs.Year = 2020)
        /
        (SELECT hs.InfantMortalityRate
         FROM HealthStats hs
         WHERE hs.CountryCode = co.Code AND hs.Year = 2000)
        * 100, 1)                                                   AS PctOfOriginal,
    (SELECT ei.GDPGrowthPct
     FROM EconomicIndicator ei
     WHERE ei.CountryCode = co.Code AND ei.Year = 2020)            AS GDPGrowth2020,
    (SELECT CONCAT(r.FirstName, ' ', r.LastName)
     FROM UN_Representative r
     WHERE r.CountryCode = co.Code AND r.TermEndDate IS NULL)       AS CurrentUNRep
FROM Country co
WHERE co.Code IN (SELECT CountryCode FROM HealthStats WHERE Year = 2000)
  AND co.Code IN (SELECT CountryCode FROM HealthStats WHERE Year = 2020)
  AND co.Code IN (SELECT CountryCode FROM EconomicIndicator WHERE Year = 2020)
  AND EXISTS (
      SELECT 1 FROM HealthStats hs_a
      WHERE hs_a.CountryCode = co.Code AND hs_a.Year = 2020
        AND hs_a.InfantMortalityRate < (
            SELECT hs_b.InfantMortalityRate * 0.50
            FROM HealthStats hs_b
            WHERE hs_b.CountryCode = co.Code AND hs_b.Year = 2000
        )
  )
ORDER BY PctOfOriginal ASC;


/*
    Query 4

    SUBQUERY QUERY

    Countries Where Physician Density Falls Below Their Continental Average (2020)

    A correlated subquery in the WHERE clause filters to countries below their
    continent's average physician density. Two additional correlated subqueries
    in the SELECT list surface the continental benchmark and the gap so the
    shortfall is immediately visible. GDP and unemployment are also pulled via
    scalar subqueries to show whether the healthcare gap tracks with economic
    weakness. No explicit JOINs are used.
*/
SELECT
    co.Name                                                         AS Country,
    co.Continent,
    (SELECT hs.PhysiciansPer1000
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2020)            AS PhysiciansPer1000,
    (SELECT ROUND(AVG(hs2.PhysiciansPer1000), 2)
     FROM HealthStats hs2
     WHERE hs2.CountryCode IN (
         SELECT Code FROM Country WHERE Continent = co.Continent
     ) AND hs2.Year = 2020)                                        AS ContinentAvgPhysicians,
    ROUND(
        (SELECT hs.PhysiciansPer1000
         FROM HealthStats hs
         WHERE hs.CountryCode = co.Code AND hs.Year = 2020)
        -
        (SELECT AVG(hs2.PhysiciansPer1000)
         FROM HealthStats hs2
         WHERE hs2.CountryCode IN (
             SELECT Code FROM Country WHERE Continent = co.Continent
         ) AND hs2.Year = 2020)
    , 2)                                                            AS GapFromContinentAvg,
    (SELECT ei.GDPGrowthPct
     FROM EconomicIndicator ei
     WHERE ei.CountryCode = co.Code AND ei.Year = 2020)            AS GDPGrowthPct,
    (SELECT ei.UnemploymentPct
     FROM EconomicIndicator ei
     WHERE ei.CountryCode = co.Code AND ei.Year = 2020)            AS UnemploymentPct
FROM Country co
WHERE co.Code IN (SELECT CountryCode FROM HealthStats WHERE Year = 2020)
  AND co.Code IN (SELECT CountryCode FROM EconomicIndicator WHERE Year = 2020)
  AND EXISTS (
      SELECT 1 FROM HealthStats hs_a
      WHERE hs_a.CountryCode = co.Code AND hs_a.Year = 2020
        AND hs_a.PhysiciansPer1000 < (
            SELECT AVG(hs3.PhysiciansPer1000)
            FROM HealthStats hs3
            WHERE hs3.CountryCode IN (
                SELECT Code FROM Country WHERE Continent = co.Continent
            ) AND hs3.Year = 2020
        )
  )
ORDER BY co.Continent, PhysiciansPer1000 ASC;


/*
    Query 5

    SUBQUERY QUERY

    Trade Balance Trajectory vs Health Expenditure Trajectory (2000 -> 2020)

    Scalar correlated subqueries fetch the 2000 and 2020 trade balance and
    health expenditure figures for each country, computing how both metrics
    shifted over two decades in a single result set. A final scalar subquery
    retrieves the current UN representative. The WHERE clause uses IN subqueries
    to ensure all four data points exist before a country appears.
    Helps the UN spot countries where health investment grew despite trade deficits
    — or vice versa — guiding targeted aid allocation.
*/
SELECT
    co.Name                                                         AS Country,
    co.Continent,
    (SELECT ei.TradeBalanceUSD
     FROM EconomicIndicator ei
     WHERE ei.CountryCode = co.Code AND ei.Year = 2000)            AS TradeBalance2000,
    (SELECT ei.TradeBalanceUSD
     FROM EconomicIndicator ei
     WHERE ei.CountryCode = co.Code AND ei.Year = 2020)            AS TradeBalance2020,
    ROUND(
        (SELECT ei.TradeBalanceUSD
         FROM EconomicIndicator ei
         WHERE ei.CountryCode = co.Code AND ei.Year = 2020)
        -
        (SELECT ei.TradeBalanceUSD
         FROM EconomicIndicator ei
         WHERE ei.CountryCode = co.Code AND ei.Year = 2000)
    , 0)                                                            AS TradeBalanceChange,
    (SELECT hs.HealthExpPctGDP
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2000)            AS HealthExp2000,
    (SELECT hs.HealthExpPctGDP
     FROM HealthStats hs
     WHERE hs.CountryCode = co.Code AND hs.Year = 2020)            AS HealthExp2020,
    ROUND(
        (SELECT hs.HealthExpPctGDP
         FROM HealthStats hs
         WHERE hs.CountryCode = co.Code AND hs.Year = 2020)
        -
        (SELECT hs.HealthExpPctGDP
         FROM HealthStats hs
         WHERE hs.CountryCode = co.Code AND hs.Year = 2000)
    , 2)                                                            AS HealthExpChange,
    (SELECT CONCAT(r.FirstName, ' ', r.LastName)
     FROM UN_Representative r
     WHERE r.CountryCode = co.Code AND r.TermEndDate IS NULL)       AS UNRepresentative
FROM Country co
WHERE co.Code IN (SELECT CountryCode FROM EconomicIndicator WHERE Year = 2000)
  AND co.Code IN (SELECT CountryCode FROM EconomicIndicator WHERE Year = 2020)
  AND co.Code IN (SELECT CountryCode FROM HealthStats WHERE Year = 2000)
  AND co.Code IN (SELECT CountryCode FROM HealthStats WHERE Year = 2020)
ORDER BY TradeBalanceChange DESC;
