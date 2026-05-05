-- CPSC 332 Final Project - David Le
use world;

/*
	Query 1
    
    JOIN QUERY
    
    Links together the GDP and inflation rate of each country.
    Lists the GDP and inflation rate of every country and relates it to the country
    The query is meant to help look at the economy 2 years after the 2008 recession, and
    also provides data for before the recession.
*/
SELECT
c.Code, c.Name,
ec.GDPGrowthPct, ec.InflationPct, ec.UnemploymentPct
FROM country AS c
INNER JOIN economicindicator AS ec
ON c.Code = ec.CountryCode
WHERE ec.Year <= 2010;

/*
	Query 2
    
	JOIN QUERY
    
    This query relates the health data of various countries such as infant mortality rate to
    factors such as country population and life expectancy of that country 2 years after the
    2008 recession.
*/
SELECT
c.Code, c.Name, c.LifeExpectancy,
hs.InfantMortalityRate, hs.AccessToWaterPct
FROM country AS c
INNER JOIN healthstats AS hs
ON c.Code = hs.CountryCode
WHERE hs.Year = 2010;


/*
	Query 3
    
	SUBQUERY QUERY
    
    This query relates the UN representatives to their countries and the overall health
    of the nation after the 2008 recession.
*/
SELECT
hs.CountryCode, hs.InfantMortalityRate, hs.InfantMortalityRate,
un.FirstName, un.LastName
FROM un_representative as un
INNER JOIN healthstats as hs
ON hs.CountryCode = un.CountryCode
WHERE hs.CountryCode in (
	SELECT
    c.Code
    FROM country AS c
);

/*
	Query 4
    
    SUBQUERY QUERY
    
    This query relates the access of water of countries to their overall surface areas.
*/
SELECT
c.Code, c.SurfaceArea,
hs.AccessToWaterPct
FROM country AS c, healthstats AS hs
WHERE c.Code IN (
	SELECT
    hs.CountryCode
    FROM healthstats as hs
    WHERE hs.AccessToWaterPct IS NOT NULL
);

/*
	Query 5
    
    SUBQUERY QUERY
    
    This query relates the countries whose official languages are spoken by their population
    percentage and the economic indicators.
*/
SELECT
c.code, c.Name,
ec.GDPGrowthPct, ec.year,
cl.Language, cl.Percentage
FROM country AS c
JOIN economicindicator AS ec
	ON c.Code = ec.CountryCode
JOIN countrylanguage AS cl
	ON c.Code = cl.CountryCode
WHERE c.Code IN
(
	SELECT
    cl.CountryCode
    FROM countryLanguage as cl
    WHERE cl.IsOfficial = True
);










