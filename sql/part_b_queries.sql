-- Part B: 20 innovative queries for world database project
-- Requirements satisfied:
--   * 10 join-based queries (Q1-Q10)
--   * 10 subquery-based queries (Q11-Q20)
--   * Base tables + added tables are mixed across the full set

-- ==================== JOIN QUERIES ====================

-- Q1: Countries with their climate risk and latest available GDP value
SELECT c.Code, c.Name, cra.risk_level, g.record_year, g.gdp_usd_billion
FROM country c
JOIN climate_risk_assessment cra ON cra.country_code = c.Code
JOIN country_gdp_history g ON g.country_code = c.Code
WHERE g.record_year = (
  SELECT MAX(g2.record_year) FROM country_gdp_history g2 WHERE g2.country_code = c.Code
)
ORDER BY g.gdp_usd_billion DESC;

-- Q2: Top populous cities among countries with High climate risk
SELECT ci.Name AS city_name, c.Name AS country_name, ci.Population AS city_population
FROM city ci
JOIN country c ON c.Code = ci.CountryCode
JOIN climate_risk_assessment cra ON cra.country_code = c.Code
WHERE cra.risk_level = 'High'
ORDER BY ci.Population DESC
LIMIT 20;

-- Q3: Official language coverage for active G20 members
SELECT c.Name AS country_name, cl.Language, cl.Percentage
FROM country c
JOIN country_organization_membership m ON m.country_code = c.Code
JOIN international_organization io ON io.organization_id = m.organization_id
JOIN countrylanguage cl ON cl.CountryCode = c.Code
WHERE io.organization_name = 'G20'
  AND m.membership_status = 'Active'
  AND cl.IsOfficial = 'T'
ORDER BY cl.Percentage DESC;

-- Q4: Organizations and number of active member countries
SELECT io.organization_name, COUNT(*) AS active_members
FROM international_organization io
JOIN country_organization_membership m ON m.organization_id = io.organization_id
WHERE m.membership_status = 'Active'
GROUP BY io.organization_name
ORDER BY active_members DESC;

-- Q5: GDP growth by continent for the latest recorded year
SELECT c.Continent, AVG(g.gdp_growth_pct) AS avg_growth_pct
FROM country c
JOIN country_gdp_history g ON g.country_code = c.Code
WHERE g.record_year = (SELECT MAX(record_year) FROM country_gdp_history)
GROUP BY c.Continent
HAVING COUNT(*) >= 2
ORDER BY avg_growth_pct DESC;

-- Q6: Countries in organizations headquartered in a different country
SELECT DISTINCT c.Name AS member_country, io.organization_name, hq.Name AS headquarters_country
FROM country_organization_membership m
JOIN country c ON c.Code = m.country_code
JOIN international_organization io ON io.organization_id = m.organization_id
JOIN country hq ON hq.Code = io.headquarters_country_code
WHERE c.Code <> hq.Code
ORDER BY io.organization_name, member_country;

-- Q7: Largest city per country for countries tracked in climate risk table
SELECT c.Name AS country_name, ci.Name AS largest_city, ci.Population
FROM country c
JOIN climate_risk_assessment cra ON cra.country_code = c.Code
JOIN city ci ON ci.CountryCode = c.Code
LEFT JOIN city ci2
  ON ci2.CountryCode = ci.CountryCode
 AND ci2.Population > ci.Population
WHERE ci2.ID IS NULL
ORDER BY ci.Population DESC;

-- Q8: Countries with low risk and positive GDP growth in latest recorded year
SELECT c.Name, cra.risk_score, g.gdp_growth_pct
FROM country c
JOIN climate_risk_assessment cra ON cra.country_code = c.Code
JOIN country_gdp_history g ON g.country_code = c.Code
WHERE cra.risk_level = 'Low'
  AND g.record_year = (SELECT MAX(record_year) FROM country_gdp_history)
  AND g.gdp_growth_pct > 0
ORDER BY g.gdp_growth_pct DESC;

-- Q9: City density proxy: top countries by average tracked city population
SELECT c.Name AS country_name, AVG(ci.Population) AS avg_city_population
FROM country c
JOIN city ci ON ci.CountryCode = c.Code
JOIN country_gdp_history g ON g.country_code = c.Code
GROUP BY c.Code, c.Name
HAVING COUNT(ci.ID) >= 3
ORDER BY avg_city_population DESC
LIMIT 20;

-- Q10: UN members with above-country average city population
SELECT c.Name AS country_name, AVG(ci.Population) AS avg_city_pop
FROM country c
JOIN city ci ON ci.CountryCode = c.Code
JOIN country_organization_membership m ON m.country_code = c.Code
JOIN international_organization io ON io.organization_id = m.organization_id
WHERE io.organization_name = 'United Nations'
GROUP BY c.Code, c.Name
HAVING AVG(ci.Population) > (
  SELECT AVG(ci_all.Population) FROM city ci_all
)
ORDER BY avg_city_pop DESC;

-- ==================== SUBQUERY QUERIES ====================

-- Q11: Countries with population above global average
SELECT c.Code, c.Name, c.Population
FROM country c
WHERE c.Code IN (SELECT country_code FROM climate_risk_assessment)
  AND c.Population > (SELECT AVG(c2.Population) FROM country c2 WHERE c2.Code IN (SELECT country_code FROM climate_risk_assessment))
ORDER BY c.Population DESC;

-- Q12: Countries with more than median number of official languages proxy
SELECT c.Code, c.Name,
       (SELECT COUNT(*)
        FROM countrylanguage cl
        WHERE cl.CountryCode = c.Code AND cl.IsOfficial = 'T') AS official_language_count
FROM country c
WHERE c.Code IN (SELECT country_code FROM country_organization_membership)
  AND (SELECT COUNT(*)
       FROM countrylanguage cl
       WHERE cl.CountryCode = c.Code AND cl.IsOfficial = 'T') >= 2
ORDER BY official_language_count DESC, c.Name;

-- Q13: Countries whose latest GDP exceeds continent average for same year
SELECT c.Code, c.Name, g.gdp_usd_billion
FROM country c
JOIN country_gdp_history g ON g.country_code = c.Code
WHERE g.record_year = (SELECT MAX(g2.record_year) FROM country_gdp_history g2 WHERE g2.country_code = c.Code)
  AND g.gdp_usd_billion > (
      SELECT AVG(g3.gdp_usd_billion)
      FROM country_gdp_history g3
      JOIN country c3 ON c3.Code = g3.country_code
      WHERE c3.Continent = c.Continent
        AND g3.record_year = g.record_year
  )
ORDER BY g.gdp_usd_billion DESC;

-- Q14: Countries that belong to at least one organization headquartered in Europe
SELECT c.Code, c.Name
FROM country c
WHERE EXISTS (
  SELECT 1
  FROM country_organization_membership m
  WHERE m.country_code = c.Code
    AND m.organization_id IN (
      SELECT io.organization_id
      FROM international_organization io
      WHERE io.headquarters_country_code IN (
        SELECT Code FROM country WHERE Continent = 'Europe'
      )
    )
)
ORDER BY c.Name;

-- Q15: Countries with at least one city above their own city-pop average
SELECT c.Code, c.Name
FROM country c
WHERE c.Code IN (SELECT country_code FROM climate_risk_assessment WHERE risk_level IN ('High', 'Medium'))
  AND EXISTS (
  SELECT 1
  FROM city ci
  WHERE ci.CountryCode = c.Code
    AND ci.Population > (
      SELECT AVG(ci2.Population)
      FROM city ci2
      WHERE ci2.CountryCode = c.Code
    )
)
ORDER BY c.Name;

-- Q16: Countries where risk score is above the avg risk score of same continent
SELECT c.Code, c.Name, cra.risk_score
FROM country c
JOIN climate_risk_assessment cra ON cra.country_code = c.Code
WHERE cra.risk_score > (
  SELECT AVG(cra2.risk_score)
  FROM climate_risk_assessment cra2
  JOIN country c2 ON c2.Code = cra2.country_code
  WHERE c2.Continent = c.Continent
)
ORDER BY cra.risk_score DESC;

-- Q17: Countries whose latest GDP growth is lower than their previous recorded year
SELECT c.Code, c.Name
FROM country c
WHERE c.Code IN (SELECT country_code FROM climate_risk_assessment)
  AND EXISTS (
  SELECT 1
  FROM country_gdp_history g_latest
  WHERE g_latest.country_code = c.Code
    AND g_latest.record_year = (
      SELECT MAX(g_max.record_year)
      FROM country_gdp_history g_max
      WHERE g_max.country_code = c.Code
    )
    AND g_latest.gdp_growth_pct < (
      SELECT g_prev.gdp_growth_pct
      FROM country_gdp_history g_prev
      WHERE g_prev.country_code = c.Code
        AND g_prev.record_year = (
          SELECT MAX(g_prev2.record_year)
          FROM country_gdp_history g_prev2
          WHERE g_prev2.country_code = c.Code
            AND g_prev2.record_year < g_latest.record_year
        )
    )
)
ORDER BY c.Name;

-- Q18: Countries with at least one active membership
SELECT c.Code, c.Name
FROM country c
WHERE (
  SELECT COUNT(*)
  FROM country_organization_membership m
  WHERE m.country_code = c.Code
    AND m.membership_status = 'Active'
) >= 1
ORDER BY c.Name;

-- Q19: Countries where capital city population is above global capital average
SELECT c.Code, c.Name
FROM country c
WHERE c.Capital IS NOT NULL
  AND c.Code IN (SELECT country_code FROM climate_risk_assessment)
  AND (SELECT ci.Population FROM city ci WHERE ci.ID = c.Capital) > (
    SELECT AVG(ci2.Population)
    FROM city ci2
    WHERE ci2.ID IN (SELECT c2.Capital FROM country c2 WHERE c2.Capital IS NOT NULL)
  )
ORDER BY c.Name;

-- Q20: Countries with official language percentage above country average language percentage
SELECT c.Code, c.Name
FROM country c
WHERE c.Code IN (SELECT country_code FROM country_organization_membership)
  AND EXISTS (
  SELECT 1
  FROM countrylanguage cl
  WHERE cl.CountryCode = c.Code
    AND cl.IsOfficial = 'T'
    AND cl.Percentage > (
      SELECT AVG(cl2.Percentage)
      FROM countrylanguage cl2
      WHERE cl2.CountryCode = c.Code
    )
)
ORDER BY c.Name;
