-- ============================================================
-- CPSC 332 - World Database Project
-- Additional Tables + 20 Queries
-- Team: [Your Team Name] | Spring 2026
-- ============================================================

USE world;

-- ============================================================
-- ADDITIONAL TABLE 1: UNRegion
-- Links countries to UN regional groupings with trade bloc data
-- ============================================================
DROP TABLE IF EXISTS UNRegion;
CREATE TABLE UNRegion (
  RegionID     INT(11)      NOT NULL AUTO_INCREMENT,
  RegionName   VARCHAR(60)  NOT NULL,
  UNZone       VARCHAR(40)  NOT NULL COMMENT 'Major UN geographic zone',
  EstablishedYear SMALLINT(4) DEFAULT NULL,
  MemberCount  SMALLINT(4)  DEFAULT NULL,
  PRIMARY KEY (RegionID),
  CONSTRAINT chk_established CHECK (EstablishedYear < 2026)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO UNRegion VALUES (1,  'Western Europe',             'Europe',         1945, 28);
INSERT INTO UNRegion VALUES (2,  'Eastern Europe',             'Europe',         1945, 23);
INSERT INTO UNRegion VALUES (3,  'Northern Europe',            'Europe',         1945, 10);
INSERT INTO UNRegion VALUES (4,  'Southern Europe',            'Europe',         1945, 15);
INSERT INTO UNRegion VALUES (5,  'Sub-Saharan Africa',         'Africa',         1963, 49);
INSERT INTO UNRegion VALUES (6,  'North Africa',               'Africa',         1964, 6);
INSERT INTO UNRegion VALUES (7,  'East Africa',                'Africa',         1967, 7);
INSERT INTO UNRegion VALUES (8,  'Southern and Central Asia',  'Asia',           1985, 8);
INSERT INTO UNRegion VALUES (9,  'Southeast Asia',             'Asia',           1967, 11);
INSERT INTO UNRegion VALUES (10, 'East Asia',                  'Asia',           1945, 6);
INSERT INTO UNRegion VALUES (11, 'Middle East',                'Asia',           1945, 22);
INSERT INTO UNRegion VALUES (12, 'Caribbean',                  'North America',  1973, 15);
INSERT INTO UNRegion VALUES (13, 'Central America',            'North America',  1951, 7);
INSERT INTO UNRegion VALUES (14, 'North America',              'North America',  1945, 3);
INSERT INTO UNRegion VALUES (15, 'South America',              'South America',  1945, 12);
INSERT INTO UNRegion VALUES (16, 'Oceania',                    'Oceania',        1945, 14);
INSERT INTO UNRegion VALUES (17, 'Antarctica',                 'Antarctica',     NULL, NULL);

-- ============================================================
-- ADDITIONAL TABLE 2: CountryEconomicIndicator
-- Macroeconomic data per country (not in base tables)
-- ============================================================
DROP TABLE IF EXISTS CountryEconomicIndicator;
CREATE TABLE CountryEconomicIndicator (
  IndicatorID        INT(11)       NOT NULL AUTO_INCREMENT,
  CountryCode        CHAR(3)       NOT NULL,
  GDPPerCapitaUSD    DECIMAL(12,2) DEFAULT NULL COMMENT 'GDP per capita in USD (2000 estimate)',
  UnemploymentRate   DECIMAL(5,2)  DEFAULT NULL COMMENT 'Percentage',
  LiteracyRate       DECIMAL(5,2)  DEFAULT NULL COMMENT 'Percentage of population 15+',
  InternetUsers      DECIMAL(5,2)  DEFAULT NULL COMMENT 'Percentage of population',
  CO2EmissionsPerCap DECIMAL(8,2)  DEFAULT NULL COMMENT 'Metric tonnes per capita',
  RecordYear         SMALLINT(4)   NOT NULL DEFAULT 2000,
  PRIMARY KEY (IndicatorID),
  CONSTRAINT fk_eco_country FOREIGN KEY (CountryCode) REFERENCES Country(Code)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_unemployment CHECK (UnemploymentRate BETWEEN 0 AND 100),
  CONSTRAINT chk_literacy      CHECK (LiteracyRate     BETWEEN 0 AND 100),
  CONSTRAINT chk_internet      CHECK (InternetUsers     BETWEEN 0 AND 100),
  CONSTRAINT chk_record_year   CHECK (RecordYear < 2026)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO CountryEconomicIndicator VALUES (NULL,'USA',  36200.00, 4.00, 99.00, 54.30, 19.80, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'CHN',   860.00, 3.10, 85.80,  2.60,  2.20, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'DEU',  25300.00, 7.90, 99.00, 37.70, 10.20, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'FRA',  24200.00, 9.50, 99.00, 26.00,  6.80, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'GBR',  23400.00, 5.60, 99.00, 57.10,  9.40, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'JPN',  32100.00, 4.70, 99.00, 49.90, 10.10, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'BRA',   4420.00, 7.10, 85.40,  4.70,  1.80, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'IND',    440.00, 4.30, 57.20,  0.70,  1.10, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'RUS',   1660.00, 9.80, 99.60,  2.00,  9.80, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'AUS',  22400.00, 6.30, 99.00, 46.80, 17.40, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'CAN',  27100.00, 6.80, 99.00, 51.30, 16.50, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'MEX',   5070.00, 2.20, 91.40,  5.10,  3.70, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'ZAF',   3020.00,26.70, 86.40,  6.90,  7.20, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'ARG',   7600.00,15.00, 96.90, 10.10,  3.70, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'NGA',    290.00, 5.10, 64.10,  0.10,  0.60, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'KOR',   8910.00, 4.10, 98.10, 44.70, 10.50, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'IDN',    720.00, 6.10, 87.90,  0.90,  1.20, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'SAU',   8460.00, 8.00, 78.10, 12.50, 11.60, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'NLD',  24400.00, 2.90, 99.00, 49.20,  9.60, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'CHE',  38200.00, 1.90, 99.00, 47.70,  5.80, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'SWE',  26700.00, 5.90, 99.00, 64.60,  5.90, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'NOR',  35000.00, 3.40, 99.00, 52.00,  7.80, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'BGD',    380.00, 3.50, 41.10,  0.10,  0.20, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'PAK',    470.00, 5.90, 45.00,  0.30,  0.70, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'ETH',    110.00, 8.00, 35.50,  0.00,  0.10, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'PHL',    860.00, 9.60, 95.10,  2.00,  1.00, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'VNM',    390.00, 6.40, 93.40,  1.30,  0.80, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'POL',   4000.00,16.20, 99.80, 17.40,  8.20, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'UKR',    700.00,11.60, 99.70,  1.50,  5.60, 2000);
INSERT INTO CountryEconomicIndicator VALUES (NULL,'EGY',   1600.00, 9.80, 55.60,  1.00,  1.70, 2000);

-- ============================================================
-- ADDITIONAL TABLE 3: UNSustainabilityGoal
-- Tracks each country's SDG score (proxy data, circa 2000)
-- ============================================================
DROP TABLE IF EXISTS UNSustainabilityGoal;
CREATE TABLE UNSustainabilityGoal (
  SDGID              INT(11)      NOT NULL AUTO_INCREMENT,
  CountryCode        CHAR(3)      NOT NULL,
  NoPoverty          TINYINT(3)   DEFAULT NULL COMMENT 'Score 0-100',
  ZeroHunger         TINYINT(3)   DEFAULT NULL,
  GoodHealth         TINYINT(3)   DEFAULT NULL,
  QualityEducation   TINYINT(3)   DEFAULT NULL,
  CleanEnergy        TINYINT(3)   DEFAULT NULL,
  ClimateAction      TINYINT(3)   DEFAULT NULL,
  OverallSDGScore    DECIMAL(5,2) DEFAULT NULL COMMENT 'Composite 0-100',
  AssessmentYear     SMALLINT(4)  DEFAULT 2000,
  PRIMARY KEY (SDGID),
  CONSTRAINT fk_sdg_country FOREIGN KEY (CountryCode) REFERENCES Country(Code)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_sdg_year CHECK (AssessmentYear < 2026)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO UNSustainabilityGoal VALUES (NULL,'USA', 72,80,82,85,70,55,74.00,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'CHN', 55,62,68,75,60,48,61.33,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'DEU', 85,88,87,90,80,72,83.67,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'FRA', 83,86,88,89,78,70,82.33,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'GBR', 82,85,86,88,76,68,80.83,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'JPN', 88,84,92,91,75,65,82.50,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'BRA', 48,52,63,68,55,44,55.00,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'IND', 28,35,45,52,40,38,39.67,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'RUS', 60,65,70,82,62,42,63.50,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'AUS', 80,84,88,87,72,60,78.50,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'CAN', 82,85,87,89,74,65,80.33,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'MEX', 42,48,65,70,52,45,53.67,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'ZAF', 35,40,38,62,45,40,43.33,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'ARG', 50,55,70,75,58,48,59.33,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'NGA', 18,22,32,38,25,28,27.17,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'KOR', 78,80,85,88,70,58,76.50,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'IDN', 32,38,55,60,42,38,44.17,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'SAU', 65,70,74,72,60,35,62.67,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'NLD', 86,88,88,91,82,74,84.83,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'CHE', 88,90,91,93,85,76,87.17,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'SWE', 90,91,92,94,88,80,89.17,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'NOR', 91,92,93,95,86,78,89.17,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'BGD', 20,28,40,42,30,32,32.00,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'PAK', 22,30,38,40,28,30,31.33,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'ETH', 12,18,30,33,20,25,23.00,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'PHL', 38,42,62,68,45,40,49.17,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'VNM', 40,50,62,70,48,42,52.00,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'POL', 70,74,78,82,65,55,70.67,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'UKR', 58,62,68,80,55,40,60.50,2000);
INSERT INTO UNSustainabilityGoal VALUES (NULL,'EGY', 32,38,55,58,42,38,43.83,2000);

-- ============================================================
-- ADD FOREIGN KEY CONSTRAINTS TO BASE TABLES (referential integrity)
-- ============================================================

-- City.CountryCode → Country.Code
ALTER TABLE City
  ADD CONSTRAINT fk_city_country
  FOREIGN KEY (CountryCode) REFERENCES Country(Code)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- CountryLanguage.CountryCode → Country.Code
ALTER TABLE CountryLanguage
  ADD CONSTRAINT fk_lang_country
  FOREIGN KEY (CountryCode) REFERENCES Country(Code)
  ON DELETE CASCADE ON UPDATE CASCADE;

-- Country.Capital → City.ID
ALTER TABLE Country
  ADD CONSTRAINT fk_country_capital
  FOREIGN KEY (Capital) REFERENCES City(ID)
  ON DELETE SET NULL ON UPDATE CASCADE;


-- ============================================================
-- ============================================================
-- PROJECT PART B: 20 QUERIES
-- ============================================================
-- ============================================================

-- ============================================================
-- QUERIES WITH JOINS (10 required)
-- ============================================================

-- QUERY 1 (JOIN)
-- Purpose: Identify countries with the highest GNP that also
-- have a life expectancy above the world average. Useful for
-- understanding wealth–longevity correlation.
SELECT
    c.Name                                   AS Country,
    c.Continent,
    c.GNP,
    c.LifeExpectancy,
    e.GDPPerCapitaUSD,
    e.LiteracyRate
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
WHERE c.LifeExpectancy > (SELECT AVG(LifeExpectancy) FROM Country WHERE LifeExpectancy IS NOT NULL)
  AND c.GNP IS NOT NULL
ORDER BY c.GNP DESC
LIMIT 20;

-- QUERY 2 (JOIN)
-- Purpose: Find which official languages are spoken in countries
-- with the largest populations, revealing dominant world languages.
SELECT
    cl.Language,
    SUM(c.Population)                        AS TotalSpeakerPopulation,
    COUNT(DISTINCT c.Code)                   AS NumberOfCountries,
    ROUND(AVG(c.LifeExpectancy), 1)          AS AvgLifeExpectancy
FROM CountryLanguage cl
JOIN Country c ON cl.CountryCode = c.Code
WHERE cl.IsOfficial = 'T'
  AND c.Population IS NOT NULL
GROUP BY cl.Language
HAVING COUNT(DISTINCT c.Code) >= 3
ORDER BY TotalSpeakerPopulation DESC
LIMIT 15;

-- QUERY 3 (JOIN)
-- Purpose: Show the top 10 most populous cities alongside
-- their country's GNP and SDG score to reveal urban wealth patterns.
SELECT
    ci.Name                                  AS CityName,
    ci.Population                            AS CityPopulation,
    c.Name                                   AS Country,
    c.GNP,
    s.OverallSDGScore
FROM City ci
JOIN Country c ON ci.CountryCode = c.Code
JOIN UNSustainabilityGoal s ON c.Code = s.CountryCode
WHERE ci.Population IS NOT NULL
ORDER BY ci.Population DESC
LIMIT 10;

-- QUERY 4 (JOIN)
-- Purpose: Compare CO2 emissions vs SDG Climate Action score
-- per country, identifying countries that score well or poorly
-- relative to their actual emissions.
SELECT
    c.Name                                   AS Country,
    c.Continent,
    e.CO2EmissionsPerCap,
    s.ClimateAction                          AS ClimateActionScore,
    s.OverallSDGScore,
    ROUND(e.CO2EmissionsPerCap / NULLIF(s.ClimateAction, 0), 3)
                                             AS EmissionsPerScorePoint
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
JOIN UNSustainabilityGoal s    ON c.Code = s.CountryCode
WHERE e.CO2EmissionsPerCap IS NOT NULL
  AND s.ClimateAction IS NOT NULL
ORDER BY e.CO2EmissionsPerCap DESC;

-- QUERY 5 (JOIN)
-- Purpose: Identify capital cities and their populations relative
-- to the country's total, revealing primate city dominance.
SELECT
    c.Name                                   AS Country,
    ci.Name                                  AS CapitalCity,
    ci.Population                            AS CapitalPop,
    c.Population                             AS CountryPop,
    ROUND((ci.Population / c.Population) * 100, 2)
                                             AS CapitalSharePct
FROM Country c
JOIN City ci ON c.Capital = ci.ID
WHERE c.Population > 0
  AND ci.Population IS NOT NULL
ORDER BY CapitalSharePct DESC
LIMIT 20;

-- QUERY 6 (JOIN)
-- Purpose: Rank continents by average literacy rate using
-- economic indicator data joined to country geography.
SELECT
    c.Continent,
    COUNT(DISTINCT c.Code)                   AS CountryCount,
    ROUND(AVG(e.LiteracyRate), 2)            AS AvgLiteracyRate,
    ROUND(AVG(e.GDPPerCapitaUSD), 2)         AS AvgGDPPerCapita,
    ROUND(AVG(c.LifeExpectancy), 1)          AS AvgLifeExpectancy
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
GROUP BY c.Continent
ORDER BY AvgLiteracyRate DESC;

-- QUERY 7 (JOIN)
-- Purpose: Find countries where internet usage exceeds 40%
-- that also have official English or French, showing digital
-- adoption in globally connected language communities.
SELECT
    c.Name                                   AS Country,
    c.Continent,
    cl.Language,
    e.InternetUsers                          AS InternetPct,
    e.GDPPerCapitaUSD
FROM Country c
JOIN CountryLanguage cl              ON c.Code = cl.CountryCode
JOIN CountryEconomicIndicator e      ON c.Code = e.CountryCode
WHERE cl.IsOfficial = 'T'
  AND cl.Language IN ('English','French')
  AND e.InternetUsers > 40
ORDER BY e.InternetUsers DESC;

-- QUERY 8 (JOIN)
-- Purpose: Show the SDG education and health scores alongside
-- life expectancy for each country — evaluating whether UN goals
-- track with real-world health outcomes.
SELECT
    c.Name                                   AS Country,
    c.Region,
    c.LifeExpectancy,
    s.QualityEducation                       AS EducationScore,
    s.GoodHealth                             AS HealthScore,
    ROUND((s.QualityEducation + s.GoodHealth) / 2.0, 1)
                                             AS AvgSocialScore
FROM Country c
JOIN UNSustainabilityGoal s ON c.Code = s.CountryCode
WHERE c.LifeExpectancy IS NOT NULL
ORDER BY c.LifeExpectancy DESC
LIMIT 20;

-- QUERY 9 (JOIN)
-- Purpose: Identify districts within countries that have multiple
-- large cities (>100k), joined to country GNP data — showing
-- industrialized urban corridors.
SELECT
    c.Name                                   AS Country,
    ci.District,
    COUNT(ci.ID)                             AS CityCount,
    SUM(ci.Population)                       AS DistrictUrbanPop,
    c.GNP
FROM City ci
JOIN Country c ON ci.CountryCode = c.Code
WHERE ci.Population > 100000
GROUP BY c.Name, ci.District, c.GNP
HAVING COUNT(ci.ID) >= 2
ORDER BY DistrictUrbanPop DESC
LIMIT 20;

-- QUERY 10 (JOIN)
-- Purpose: Cross-reference unemployment rate with poverty SDG
-- score to find countries where economic hardship and development
-- gaps coincide — critical for UN aid prioritization.
SELECT
    c.Name                                   AS Country,
    c.Continent,
    e.UnemploymentRate,
    s.NoPoverty                              AS PovertyScore,
    s.ZeroHunger                             AS HungerScore,
    c.LifeExpectancy,
    c.Population
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
JOIN UNSustainabilityGoal s    ON c.Code = s.CountryCode
WHERE e.UnemploymentRate IS NOT NULL
ORDER BY e.UnemploymentRate DESC;


-- ============================================================
-- QUERIES WITH SUBQUERIES (10 required)
-- ============================================================

-- QUERY 11 (SUBQUERY)
-- Purpose: Find all countries whose GNP exceeds the average GNP
-- of their own continent — identifying regional economic leaders.
SELECT
    c.Name,
    c.Continent,
    c.GNP,
    c.Population,
    (SELECT ROUND(AVG(c2.GNP), 2)
     FROM Country c2
     WHERE c2.Continent = c.Continent
       AND c2.GNP IS NOT NULL)              AS ContinentAvgGNP
FROM Country c
WHERE c.GNP > (
    SELECT AVG(c3.GNP)
    FROM Country c3
    WHERE c3.Continent = c.Continent
      AND c3.GNP IS NOT NULL
)
ORDER BY c.Continent, c.GNP DESC;

-- QUERY 12 (SUBQUERY)
-- Purpose: List countries whose life expectancy is below the
-- world average and also have a poor SDG health score (< 50),
-- identifying the most urgent global health crises.
SELECT
    c.Name,
    c.Continent,
    c.LifeExpectancy,
    (SELECT ROUND(AVG(LifeExpectancy), 1) FROM Country WHERE LifeExpectancy IS NOT NULL)
                                            AS WorldAvgLifeExpectancy,
    s.GoodHealth                            AS SDGHealthScore
FROM Country c
JOIN UNSustainabilityGoal s ON c.Code = s.CountryCode
WHERE c.LifeExpectancy < (
    SELECT AVG(LifeExpectancy) FROM Country WHERE LifeExpectancy IS NOT NULL
)
  AND s.GoodHealth < 50
ORDER BY c.LifeExpectancy ASC;

-- QUERY 13 (SUBQUERY)
-- Purpose: Identify languages spoken in MORE countries than English
-- is spoken (as an official language) — revealing surprising
-- linguistic reach.
SELECT
    cl.Language,
    COUNT(DISTINCT cl.CountryCode)          AS OfficialCountryCount
FROM CountryLanguage cl
WHERE cl.IsOfficial = 'T'
GROUP BY cl.Language
HAVING COUNT(DISTINCT cl.CountryCode) > (
    SELECT COUNT(DISTINCT CountryCode)
    FROM CountryLanguage
    WHERE Language = 'English' AND IsOfficial = 'T'
)
ORDER BY OfficialCountryCount DESC;

-- QUERY 14 (SUBQUERY)
-- Purpose: Retrieve countries that have at least one city with
-- a population larger than the country's average city population
-- multiplied by 5 — pinpointing extreme primate cities.
SELECT DISTINCT
    c.Name                                  AS Country,
    c.Continent,
    c.Population                            AS CountryPopulation,
    (SELECT MAX(ci2.Population)
     FROM City ci2
     WHERE ci2.CountryCode = c.Code)       AS LargestCityPop
FROM Country c
WHERE EXISTS (
    SELECT 1
    FROM City ci
    WHERE ci.CountryCode = c.Code
      AND ci.Population > 5 * (
          SELECT AVG(ci3.Population)
          FROM City ci3
          WHERE ci3.CountryCode = c.Code
      )
)
ORDER BY LargestCityPop DESC
LIMIT 15;

-- QUERY 15 (SUBQUERY)
-- Purpose: Show countries with GDP per capita above the global
-- median but with an overall SDG score below the average —
-- highlighting wealthy nations failing on sustainability.
SELECT
    c.Name,
    c.Continent,
    e.GDPPerCapitaUSD,
    s.OverallSDGScore
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
JOIN UNSustainabilityGoal s    ON c.Code = s.CountryCode
WHERE e.GDPPerCapitaUSD > (
    SELECT AVG(GDPPerCapitaUSD) FROM CountryEconomicIndicator
)
  AND s.OverallSDGScore < (
    SELECT AVG(OverallSDGScore) FROM UNSustainabilityGoal
)
ORDER BY e.GDPPerCapitaUSD DESC;

-- QUERY 16 (SUBQUERY)
-- Purpose: For each continent, find the country with the lowest
-- literacy rate — flagging the most educationally underserved
-- nation per region for targeted UN intervention.
SELECT
    c.Continent,
    c.Name                                  AS Country,
    e.LiteracyRate,
    c.Population
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
WHERE e.LiteracyRate = (
    SELECT MIN(e2.LiteracyRate)
    FROM Country c2
    JOIN CountryEconomicIndicator e2 ON c2.Code = e2.CountryCode
    WHERE c2.Continent = c.Continent
)
ORDER BY c.Continent;

-- QUERY 17 (SUBQUERY)
-- Purpose: List countries where internet access is BELOW the
-- continent average — identifying the digital divide within
-- each region, critical for UN digital inclusion programs.
SELECT
    c.Name,
    c.Continent,
    e.InternetUsers                         AS InternetPct,
    (SELECT ROUND(AVG(e2.InternetUsers), 2)
     FROM Country c2
     JOIN CountryEconomicIndicator e2 ON c2.Code = e2.CountryCode
     WHERE c2.Continent = c.Continent)     AS ContinentAvgInternet
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
WHERE e.InternetUsers < (
    SELECT AVG(e3.InternetUsers)
    FROM Country c3
    JOIN CountryEconomicIndicator e3 ON c3.Code = e3.CountryCode
    WHERE c3.Continent = c.Continent
)
ORDER BY c.Continent, e.InternetUsers ASC;

-- QUERY 18 (SUBQUERY)
-- Purpose: Find countries with CO2 emissions per capita
-- in the top 25% globally but with a population under 10 million —
-- revealing small, high-polluting nations often overlooked.
SELECT
    c.Name,
    c.Continent,
    c.Population,
    e.CO2EmissionsPerCap,
    s.ClimateAction                         AS ClimateScore
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
JOIN UNSustainabilityGoal s    ON c.Code = s.CountryCode
WHERE c.Population < 10000000
  AND e.CO2EmissionsPerCap > (
    SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CO2EmissionsPerCap)
    -- MySQL equivalent using subquery:
    -- Approximated below
    FROM CountryEconomicIndicator
    WHERE CO2EmissionsPerCap IS NOT NULL
  )
ORDER BY e.CO2EmissionsPerCap DESC;

-- QUERY 18 (SUBQUERY - MySQL-compatible version replacing percentile)
-- Purpose: Same as above using MySQL-compatible rank-based approach.
SELECT
    c.Name,
    c.Continent,
    c.Population,
    e.CO2EmissionsPerCap,
    s.ClimateAction                         AS ClimateScore
FROM Country c
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
JOIN UNSustainabilityGoal s    ON c.Code = s.CountryCode
WHERE c.Population < 10000000
  AND e.CO2EmissionsPerCap > (
    SELECT AVG(CO2EmissionsPerCap) + STDDEV(CO2EmissionsPerCap)
    FROM CountryEconomicIndicator
    WHERE CO2EmissionsPerCap IS NOT NULL
)
ORDER BY e.CO2EmissionsPerCap DESC;

-- QUERY 19 (SUBQUERY)
-- Purpose: Show all countries that speak a language also spoken
-- officially in the top-5 most populous countries — mapping
-- global linguistic reach of population giants.
SELECT DISTINCT
    c.Name                                  AS Country,
    c.Continent,
    c.Population,
    cl.Language
FROM Country c
JOIN CountryLanguage cl ON c.Code = cl.CountryCode
WHERE cl.IsOfficial = 'T'
  AND cl.Language IN (
    SELECT DISTINCT cl2.Language
    FROM CountryLanguage cl2
    WHERE cl2.IsOfficial = 'T'
      AND cl2.CountryCode IN (
        SELECT Code FROM Country ORDER BY Population DESC LIMIT 5
      )
)
  AND c.Code NOT IN (
    SELECT Code FROM Country ORDER BY Population DESC LIMIT 5
  )
ORDER BY c.Population DESC
LIMIT 20;

-- QUERY 20 (SUBQUERY)
-- Purpose: Find countries ranked in the top half by SDG overall
-- score that are also in the bottom half by GNP — demonstrating
-- that high sustainability doesn't always require wealth.
SELECT
    c.Name,
    c.Continent,
    c.GNP,
    s.OverallSDGScore,
    e.LiteracyRate
FROM Country c
JOIN UNSustainabilityGoal s    ON c.Code = s.CountryCode
JOIN CountryEconomicIndicator e ON c.Code = e.CountryCode
WHERE s.OverallSDGScore > (
    SELECT AVG(OverallSDGScore) FROM UNSustainabilityGoal
)
  AND c.GNP < (
    SELECT AVG(GNP) FROM Country WHERE GNP IS NOT NULL
)
ORDER BY s.OverallSDGScore DESC;

-- ============================================================
-- END OF PROJECT SQL FILE
-- ============================================================
