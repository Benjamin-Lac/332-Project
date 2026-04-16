-- World Database Physical Model
-- Base tables: country, city, countrylanguage (compatible with common MySQL world sample schema)
-- Additional tables: international_organization, country_organization_membership,
--                    country_gdp_history, climate_risk_assessment

CREATE TABLE IF NOT EXISTS country (
    Code CHAR(3) PRIMARY KEY,
    Name VARCHAR(52) NOT NULL,
    Continent VARCHAR(30) NOT NULL,
    Region VARCHAR(26) NOT NULL,
    SurfaceArea DECIMAL(10,2) NOT NULL CHECK (SurfaceArea >= 0),
    IndepYear SMALLINT,
    Population INT NOT NULL CHECK (Population >= 0),
    LifeExpectancy DECIMAL(3,1),
    GNP DECIMAL(10,2),
    GNPOld DECIMAL(10,2),
    LocalName VARCHAR(45) NOT NULL,
    GovernmentForm VARCHAR(45) NOT NULL,
    HeadOfState VARCHAR(60),
    Capital INT,
    Code2 CHAR(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS city (
    ID INT PRIMARY KEY,
    Name VARCHAR(35) NOT NULL,
    CountryCode CHAR(3) NOT NULL,
    District VARCHAR(20) NOT NULL,
    Population INT NOT NULL CHECK (Population >= 0),
    CONSTRAINT fk_city_country FOREIGN KEY (CountryCode)
        REFERENCES country(Code)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS countrylanguage (
    CountryCode CHAR(3) NOT NULL,
    Language VARCHAR(30) NOT NULL,
    IsOfficial CHAR(1) NOT NULL CHECK (IsOfficial IN ('T','F')),
    Percentage DECIMAL(4,1) NOT NULL CHECK (Percentage >= 0 AND Percentage <= 100),
    PRIMARY KEY (CountryCode, Language),
    CONSTRAINT fk_countrylanguage_country FOREIGN KEY (CountryCode)
        REFERENCES country(Code)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Optional in environments where this FK is not already present:
-- ALTER TABLE country
--     ADD CONSTRAINT fk_country_capital_city FOREIGN KEY (Capital)
--     REFERENCES city(ID)
--     ON UPDATE CASCADE
--     ON DELETE SET NULL;

-- Additional table 1
CREATE TABLE IF NOT EXISTS international_organization (
    organization_id INT PRIMARY KEY,
    organization_name VARCHAR(100) NOT NULL UNIQUE,
    founded_date DATE NOT NULL,
    headquarters_country_code CHAR(3) NOT NULL,
    CONSTRAINT chk_org_founded_date CHECK (founded_date < CURRENT_DATE),
    CONSTRAINT fk_org_headquarters_country FOREIGN KEY (headquarters_country_code)
        REFERENCES country(Code)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Additional table 2
CREATE TABLE IF NOT EXISTS country_organization_membership (
    membership_id INT PRIMARY KEY,
    country_code CHAR(3) NOT NULL,
    organization_id INT NOT NULL,
    joined_date DATE NOT NULL,
    membership_status VARCHAR(15) NOT NULL,
    CONSTRAINT uq_country_org UNIQUE (country_code, organization_id),
    CONSTRAINT chk_membership_joined_date CHECK (joined_date < CURRENT_DATE),
    CONSTRAINT chk_membership_status CHECK (membership_status IN ('Active', 'Observer', 'Suspended')),
    CONSTRAINT fk_membership_country FOREIGN KEY (country_code)
        REFERENCES country(Code)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_membership_org FOREIGN KEY (organization_id)
        REFERENCES international_organization(organization_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Additional table 3
CREATE TABLE IF NOT EXISTS country_gdp_history (
    country_code CHAR(3) NOT NULL,
    record_year SMALLINT NOT NULL,
    gdp_usd_billion DECIMAL(12,2) NOT NULL CHECK (gdp_usd_billion > 0),
    gdp_growth_pct DECIMAL(5,2),
    PRIMARY KEY (country_code, record_year),
    CONSTRAINT chk_gdp_year CHECK (record_year BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE)),
    CONSTRAINT fk_gdp_country FOREIGN KEY (country_code)
        REFERENCES country(Code)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Additional table 4
CREATE TABLE IF NOT EXISTS climate_risk_assessment (
    country_code CHAR(3) PRIMARY KEY,
    risk_score DECIMAL(5,2) NOT NULL CHECK (risk_score >= 0 AND risk_score <= 100),
    risk_level VARCHAR(10) NOT NULL CHECK (risk_level IN ('Low', 'Medium', 'High')),
    assessed_on DATE NOT NULL CHECK (assessed_on <= CURRENT_DATE),
    CONSTRAINT fk_climate_country FOREIGN KEY (country_code)
        REFERENCES country(Code)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
