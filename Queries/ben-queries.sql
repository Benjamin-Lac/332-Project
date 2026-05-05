-- CPSC 332 Final Project
USE world;

/*
    Query 1

    JOIN QUERY

    Population Density vs Development Indicators (2020)

    Computes each country's population density (people per km²) by dividing
    Population by SurfaceArea — a column untouched by all other queries.
    Joined with EconomicIndicator and HealthStats to reveal whether densely
    packed nations show different economic and healthcare outcomes.
    Useful for the UN to identify where overcrowding strains public services.
*/
SELECT
    co.Name                                         AS Country,
    co.Continent,
    co.Population,
    co.SurfaceArea,
    ROUND(co.Population / co.SurfaceArea, 2)        AS PopDensityPerKm2,
    ei.GDPGrowthPct,
    ei.UnemploymentPct,
    hs.AccessToWaterPct,
    hs.PhysiciansPer1000
FROM Country co
JOIN EconomicIndicator ei
    ON co.Code = ei.CountryCode AND ei.Year = 2020
JOIN HealthStats hs
    ON co.Code = hs.CountryCode AND hs.Year = 2020
WHERE co.SurfaceArea > 0
  AND co.Population IS NOT NULL
ORDER BY PopDensityPerKm2 DESC;


/*
    Query 2

    JOIN QUERY

    Historical GNP Growth Rate with Current UN Representation and Health Stats

    Uses Country.GNPOld (the prior-period GNP snapshot) alongside Country.GNP
    to compute a GNP growth percentage — a column pair no other query touches.
    Joined with UN_Representative and HealthStats to answer: do countries that
    historically grew faster now have better health infrastructure and active
    UN diplomacy?
*/
SELECT
    co.Name                                         AS Country,
    co.Continent,
    co.GNP,
    co.GNPOld,
    ROUND(co.GNP - co.GNPOld, 2)                   AS GNPChange,
    ROUND((co.GNP - co.GNPOld) / NULLIF(co.GNPOld, 0) * 100, 2) AS GNPGrowthPct,
    CONCAT(r.FirstName, ' ', r.LastName)            AS UNRepresentative,
    r.AppointDate,
    hs.HealthExpPctGDP,
    hs.HospitalBedsPer1000
FROM Country co
JOIN UN_Representative r
    ON co.Code = r.CountryCode
JOIN HealthStats hs
    ON co.Code = hs.CountryCode AND hs.Year = 2020
WHERE co.GNP    IS NOT NULL
  AND co.GNPOld IS NOT NULL
ORDER BY GNPGrowthPct DESC;


/*
    Query 3

    SUBQUERY QUERY

    Countries That Reduced Infant Mortality by More Than 50% Since 2000

    Uses a correlated subquery to filter only countries where the 2020 infant
    mortality rate is less than half of their own 2000 rate — a dramatic health
    improvement milestone. Pulls in the current UN representative via a scalar
    subquery and joins GDP data to show whether the economic environment
    accompanied or hindered that progress.
*/
SELECT
    co.Name                                                 AS Country,
    co.Continent,
    hs2000.InfantMortalityRate                             AS InfantMort2000,
    hs2020.InfantMortalityRate                             AS InfantMort2020,
    ROUND(hs2020.InfantMortalityRate
          / hs2000.InfantMortalityRate * 100, 1)           AS PctOfOriginal,
    ei.GDPGrowthPct                                        AS GDPGrowth2020,
    (SELECT CONCAT(r.FirstName, ' ', r.LastName)
     FROM UN_Representative r
     WHERE r.CountryCode = co.Code
       AND r.TermEndDate IS NULL
     LIMIT 1)                                              AS CurrentUNRep
FROM Country co
JOIN HealthStats hs2000
    ON co.Code = hs2000.CountryCode AND hs2000.Year = 2000
JOIN HealthStats hs2020
    ON co.Code = hs2020.CountryCode AND hs2020.Year = 2020
JOIN EconomicIndicator ei
    ON co.Code = ei.CountryCode AND ei.Year = 2020
WHERE hs2020.InfantMortalityRate < (
    SELECT hs_orig.InfantMortalityRate * 0.50
    FROM HealthStats hs_orig
    WHERE hs_orig.CountryCode = co.Code
      AND hs_orig.Year = 2000
)
ORDER BY PctOfOriginal ASC;


/*
    Query 4

    SUBQUERY QUERY

    Countries Where Physician Density Falls Below Their Continental Average (2020)

    Uses a correlated subquery to compute the average physicians-per-1000 for
    each country's own continent, then filters to countries that fall below it.
    A second correlated subquery surfaces that continental average directly in
    the result set so the gap is immediately visible. Cross-joined with
    EconomicIndicator shows whether the shortfall tracks with economic weakness.
    Identifies regions where the UN should prioritise medical workforce programs.
*/
SELECT
    co.Name                                             AS Country,
    co.Continent,
    hs.PhysiciansPer1000,
    (SELECT ROUND(AVG(hs2.PhysiciansPer1000), 2)
     FROM HealthStats hs2
     JOIN Country co2 ON hs2.CountryCode = co2.Code
     WHERE co2.Continent = co.Continent
       AND hs2.Year = 2020)                             AS ContinentAvgPhysicians,
    ROUND(hs.PhysiciansPer1000 -
          (SELECT AVG(hs3.PhysiciansPer1000)
           FROM HealthStats hs3
           JOIN Country co3 ON hs3.CountryCode = co3.Code
           WHERE co3.Continent = co.Continent
             AND hs3.Year = 2020), 2)                   AS GapFromContinentAvg,
    ei.GDPGrowthPct,
    ei.UnemploymentPct
FROM Country co
JOIN HealthStats hs
    ON co.Code = hs.CountryCode AND hs.Year = 2020
JOIN EconomicIndicator ei
    ON co.Code = ei.CountryCode AND ei.Year = 2020
WHERE hs.PhysiciansPer1000 < (
    SELECT AVG(hs4.PhysiciansPer1000)
    FROM HealthStats hs4
    JOIN Country co4 ON hs4.CountryCode = co4.Code
    WHERE co4.Continent = co.Continent
      AND hs4.Year = 2020
)
ORDER BY co.Continent, hs.PhysiciansPer1000 ASC;


/*
    Query 5

    JOIN QUERY

    Trade Balance Trajectory vs Health Expenditure Trajectory (2000 → 2020)

    Joins EconomicIndicator twice (for 2000 and 2020) and HealthStats twice to
    simultaneously track how each country's trade balance and health spending
    share of GDP shifted over two decades. LEFT JOINs in the current UN
    representative so countries without a rep still appear. No other query
    compares both economic and health change vectors across the full 20-year
    window in a single result set.
    Helps the UN spot countries where health investment grew despite trade deficits
    — or vice versa — guiding targeted aid allocation.
*/
SELECT
    co.Name                                                     AS Country,
    co.Continent,
    ei2000.TradeBalanceUSD                                      AS TradeBalance2000,
    ei2020.TradeBalanceUSD                                      AS TradeBalance2020,
    ROUND(ei2020.TradeBalanceUSD - ei2000.TradeBalanceUSD, 0)  AS TradeBalanceChange,
    hs2000.HealthExpPctGDP                                      AS HealthExp2000,
    hs2020.HealthExpPctGDP                                      AS HealthExp2020,
    ROUND(hs2020.HealthExpPctGDP - hs2000.HealthExpPctGDP, 2)  AS HealthExpChange,
    CONCAT(r.FirstName, ' ', r.LastName)                        AS UNRepresentative
FROM Country co
JOIN EconomicIndicator ei2000
    ON co.Code = ei2000.CountryCode AND ei2000.Year = 2000
JOIN EconomicIndicator ei2020
    ON co.Code = ei2020.CountryCode AND ei2020.Year = 2020
JOIN HealthStats hs2000
    ON co.Code = hs2000.CountryCode AND hs2000.Year = 2000
JOIN HealthStats hs2020
    ON co.Code = hs2020.CountryCode AND hs2020.Year = 2020
LEFT JOIN UN_Representative r
    ON co.Code = r.CountryCode AND r.TermEndDate IS NULL
ORDER BY TradeBalanceChange DESC;
