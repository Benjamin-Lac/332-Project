SELECT 
    r.FirstName,
    r.LastName,
    r.Email,
    c.Name AS Country,
    c.Region,
    c.Population
FROM UN_Representative r
JOIN Country c ON r.CountryCode = c.Code
ORDER BY c.Population DESC;