-- ============================================================
-- CPSC 332 - World Database Additional Tables
-- Spring 2026
-- ============================================================

USE world;

-- ============================================================
-- TABLE 1: UN_Representative
-- Stores information about each country's UN representative
-- Links to Country via CountryCode (FK)
-- ============================================================

DROP TABLE IF EXISTS UN_Representative;
CREATE TABLE UN_Representative (
    RepID       INT(11)     NOT NULL AUTO_INCREMENT,
    CountryCode CHAR(3)     NOT NULL DEFAULT '',
    FirstName   CHAR(50)    NOT NULL,
    LastName    CHAR(50)    NOT NULL,
    Email       CHAR(100)   NOT NULL,
    AppointDate DATE        NOT NULL,
    TermEndDate DATE        DEFAULT NULL,
    CONSTRAINT chk_appoint_date CHECK (AppointDate < CURDATE()),
    CONSTRAINT chk_term_end     CHECK (TermEndDate IS NULL OR TermEndDate > AppointDate),
    PRIMARY KEY (RepID),
    FOREIGN KEY (CountryCode) REFERENCES Country(Code)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO UN_Representative (CountryCode, FirstName, LastName, Email, AppointDate, TermEndDate) VALUES
('USA', 'Linda',    'Thomas-Greenfield', 'ltg@un.org',        '2021-02-24', NULL),
('CHN', 'Zhang',    'Jun',               'zjun@un.org',       '2019-09-01', NULL),
('RUS', 'Vasily',   'Nebenzya',          'vnebenzya@un.org',  '2017-09-01', NULL),
('GBR', 'Barbara',  'Woodward',          'bwoodward@un.org',  '2020-01-07', NULL),
('FRA', 'Nicolas',  'de Rivière',        'nriviere@un.org',   '2019-09-01', NULL),
('DEU', 'Antje',    'Leendertse',        'aleendertse@un.org','2022-05-01', NULL),
('BRA', 'Sérgio',   'França Danese',     'sfdanese@un.org',   '2019-01-01', NULL),
('IND', 'Ruchira',  'Kamboj',            'rkamboj@un.org',    '2022-08-02', NULL),
('JPN', 'Kimihiro', 'Ishikane',          'kishikane@un.org',  '2019-12-21', NULL),
('ZAF', 'Mathu',    'Joyini',            'mjoyini@un.org',    '2023-06-01', NULL),
('MEX', 'Juan',     'Ramón de la Fuente','jrfuente@un.org',   '2024-01-15', NULL),
('ARG', 'Ricardo',  'Lagorio',           'rlagorio@un.org',   '2020-02-01', NULL),
('AUS', 'James',    'Larsen',            'jlarsen@un.org',    '2022-01-27', NULL),
('EGY', 'Osama',    'Abdelkhalek',       'oabdelkhalek@un.org','2021-05-14',NULL),
('NGA', 'Tijjani',  'Muhammad-Bande',    'tmbande@un.org',    '2018-11-16', '2022-11-15'),
('KEN', 'Martin',   'Kimani',            'mkimani@un.org',    '2020-02-14', NULL),
('PAK', 'Munir',    'Akram',             'makram@un.org',     '2019-02-28', NULL),
('TUR', 'Ahmet',    'Yildiz',            'ayildiz@un.org',    '2023-03-01', NULL),
('CAN', 'Bob',      'Rae',               'brae@un.org',       '2020-12-23', NULL),
('KOR', 'Joonkook', 'Hwang',             'jhwang@un.org',     '2022-02-17', NULL);


-- ============================================================
-- TABLE 2: EconomicIndicator
-- Annual economic data per country (GDP growth, inflation, etc.)
-- Links to Country via CountryCode (FK)
-- ============================================================

DROP TABLE IF EXISTS EconomicIndicator;
CREATE TABLE EconomicIndicator (
    IndicatorID     INT(11)         NOT NULL AUTO_INCREMENT,
    CountryCode     CHAR(3)         NOT NULL DEFAULT '',
    Year            YEAR            NOT NULL,
    GDPGrowthPct    DECIMAL(5,2)    DEFAULT NULL COMMENT 'Annual GDP growth %',
    InflationPct    DECIMAL(5,2)    DEFAULT NULL COMMENT 'Annual inflation %',
    UnemploymentPct DECIMAL(5,2)    DEFAULT NULL COMMENT 'Unemployment rate %',
    TradeBalanceUSD DECIMAL(15,2)   DEFAULT NULL COMMENT 'Trade balance in millions USD',
    FDIInflowUSD    DECIMAL(15,2)   DEFAULT NULL COMMENT 'Foreign direct investment inflows in millions USD',
    CONSTRAINT chk_year CHECK (Year <= YEAR(CURDATE())),
    PRIMARY KEY (IndicatorID),
    UNIQUE KEY uq_country_year (CountryCode, Year),
    FOREIGN KEY (CountryCode) REFERENCES Country(Code)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO EconomicIndicator (CountryCode, Year, GDPGrowthPct, InflationPct, UnemploymentPct, TradeBalanceUSD, FDIInflowUSD) VALUES
('USA', 2000, 4.10,  3.40,  4.00,  -379000.00,  314007.00),
('USA', 2010, 2.56,  1.64,  9.63,  -500000.00,  198000.00),
('USA', 2020,-2.77,  1.23,  8.10,  -678000.00,  156000.00),
('CHN', 2000, 8.49,  0.35,  3.10,   24100.00,    40715.00),
('CHN', 2010,10.64,  3.31,  4.10,  181600.00,  114734.00),
('CHN', 2020, 2.24,  2.42,  5.60,  535000.00,  149000.00),
('RUS', 2000,10.00, 20.78,  9.80,   60100.00,    2714.00),
('RUS', 2010, 4.50,  6.85,  7.50,  148000.00,   13810.00),
('RUS', 2020,-2.65,  3.38,  5.80,   94200.00,    8600.00),
('DEU', 2000, 2.94,  1.45,  7.90,   55000.00,   198276.00),
('DEU', 2010, 4.16,  1.10,  7.00,  154000.00,    46136.00),
('DEU', 2020,-4.62, -0.25,  5.90,  177000.00,    35576.00),
('GBR', 2000, 3.78,  0.78,  5.40,  -33000.00,   118774.00),
('GBR', 2010, 1.87,  3.27,  7.80,  -59000.00,    51202.00),
('GBR', 2020,-9.33,  0.85,  4.50,  -48000.00,    24938.00),
('JPN', 2000, 2.77, -0.68,  4.70,  116000.00,    8323.00),
('JPN', 2010, 4.19, -0.72,  5.10,   78000.00,    -1250.00),
('JPN', 2020,-4.30, -0.02,  2.80,   30000.00,    9640.00),
('IND', 2000, 3.84,  4.01,  4.30,  -11000.00,    3585.00),
('IND', 2010,10.26,  11.99, 3.50,  -44000.00,   27397.00),
('IND', 2020,-6.60,  6.62,  7.10,  -15000.00,   64072.00),
('BRA', 2000, 4.37,  7.05,  9.60,   -0700.00,   32779.00),
('BRA', 2010, 7.53,  5.04,  6.70,   20100.00,   48506.00),
('BRA', 2020,-3.88,  3.21, 13.50,  -11000.00,   37776.00),
('ZAF', 2000, 4.20,  5.34, 26.70,   -1600.00,    888.00),
('ZAF', 2010, 3.04,  4.26, 25.00,   -3600.00,    3629.00),
('ZAF', 2020,-6.96,  3.22, 32.60,   16400.00,    3100.00),
('MEX', 2000, 6.60,  9.49,  2.60,   -8300.00,   16592.00),
('MEX', 2010, 5.11,  4.16,  5.30,  -11300.00,   20680.00),
('MEX', 2020,-8.36,  3.40,  4.40,   34100.00,   29081.00),
('ARG', 2000,-0.79, -0.94, 15.10,   12700.00,   10418.00),
('ARG', 2010, 10.12, 22.90,  7.70,    3900.00,   11333.00),
('ARG', 2020,-9.90,  42.02, 11.60,   12300.00,    4894.00),
('NGA', 2000, 5.02,  6.93, 13.10,    3900.00,    1140.00),
('NGA', 2010, 8.01, 13.72, 21.40,   26000.00,    6099.00),
('NGA', 2020,-1.79, 13.25, 33.30,    2200.00,    2384.00),
('KEN', 2000, 0.60,  9.97, 12.70,   -1000.00,     111.00),
('KEN', 2010, 8.41,  3.96, 12.70,   -4300.00,     178.00),
('KEN', 2020,-0.30,  5.35, 12.00,   -5200.00,     374.00);


-- ============================================================
-- TABLE 3: HealthStats
-- Health and wellness statistics per country
-- Links to Country via CountryCode (FK)
-- ============================================================

DROP TABLE IF EXISTS HealthStats;
CREATE TABLE HealthStats (
    HealthID            INT(11)         NOT NULL AUTO_INCREMENT,
    CountryCode         CHAR(3)         NOT NULL DEFAULT '',
    Year                YEAR            NOT NULL,
    InfantMortalityRate DECIMAL(6,2)    DEFAULT NULL COMMENT 'Deaths per 1000 live births',
    PhysiciansPer1000   DECIMAL(5,2)    DEFAULT NULL COMMENT 'Doctors per 1000 people',
    HospitalBedsPer1000 DECIMAL(5,2)    DEFAULT NULL COMMENT 'Hospital beds per 1000 people',
    HealthExpPctGDP     DECIMAL(5,2)    DEFAULT NULL COMMENT 'Health expenditure as % of GDP',
    AccessToWaterPct    DECIMAL(5,2)    DEFAULT NULL COMMENT '% population with clean water access',
    CONSTRAINT chk_health_year    CHECK (Year <= YEAR(CURDATE())),
    CONSTRAINT chk_infant_mort    CHECK (InfantMortalityRate >= 0),
    CONSTRAINT chk_water_pct      CHECK (AccessToWaterPct BETWEEN 0 AND 100),
    PRIMARY KEY (HealthID),
    UNIQUE KEY uq_country_health_year (CountryCode, Year),
    FOREIGN KEY (CountryCode) REFERENCES Country(Code)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO HealthStats (CountryCode, Year, InfantMortalityRate, PhysiciansPer1000, HospitalBedsPer1000, HealthExpPctGDP, AccessToWaterPct) VALUES
('USA', 2000,  6.90,  2.27,  3.50, 13.10, 99.00),
('USA', 2010,  6.10,  2.42,  3.10, 17.10, 99.00),
('USA', 2020,  5.40,  2.61,  2.87, 19.70, 99.00),
('CHN', 2000, 32.90,  1.06,  2.39,  4.60, 80.10),
('CHN', 2010, 13.10,  1.46,  3.58,  5.10, 91.40),
('CHN', 2020,  5.60,  2.21,  4.34,  5.70, 95.90),
('RUS', 2000, 15.30,  4.20,  9.80,  5.40, 96.90),
('RUS', 2010,  7.50,  4.31,  9.21,  6.30, 97.50),
('RUS', 2020,  4.50,  3.75,  7.10,  7.60, 97.90),
('DEU', 2000,  4.40,  3.60,  9.10, 10.30, 99.90),
('DEU', 2010,  3.40,  3.82,  8.27, 11.50, 99.90),
('DEU', 2020,  3.10,  4.34,  8.00, 12.80, 99.90),
('GBR', 2000,  5.60,  2.30,  4.10,  6.90, 100.00),
('GBR', 2010,  4.20,  2.73,  2.95,  8.40, 100.00),
('GBR', 2020,  3.60,  3.00,  2.54,  9.80, 100.00),
('JPN', 2000,  3.20,  1.98,  8.10,  7.60, 100.00),
('JPN', 2010,  2.30,  2.21, 13.58, 10.00, 100.00),
('JPN', 2020,  1.80,  2.49, 13.05, 11.10, 100.00),
('IND', 2000, 67.60,  0.51,  0.70,  4.30, 78.10),
('IND', 2010, 44.60,  0.65,  0.90,  4.20, 87.60),
('IND', 2020, 27.40,  0.74,  0.53,  3.50, 93.40),
('BRA', 2000, 29.80,  1.25,  2.60,  7.30, 87.00),
('BRA', 2010, 16.70,  1.76,  2.35,  9.00, 96.60),
('BRA', 2020,  9.80,  2.31,  2.19,  9.80, 99.00),
('ZAF', 2000, 47.20,  0.74,  2.84,  8.10, 82.40),
('ZAF', 2010, 34.90,  0.77,  2.84,  8.70, 90.00),
('ZAF', 2020, 28.30,  0.91,  2.84,  8.30, 89.40),
('MEX', 2000, 21.40,  1.50,  1.00,  5.10, 88.60),
('MEX', 2010, 13.20,  1.96,  1.60,  5.90, 94.40),
('MEX', 2020,  9.10,  2.43,  1.38,  5.40, 97.20),
('ARG', 2000, 16.60,  2.88,  4.10,  9.10, 94.30),
('ARG', 2010, 13.30,  3.21,  4.70,  8.10, 98.40),
('ARG', 2020,  8.90,  4.06,  5.00,  9.80, 99.00),
('NGA', 2000, 96.40,  0.28,  1.53,  3.40, 47.80),
('NGA', 2010, 72.10,  0.38,  0.53,  3.80, 62.10),
('NGA', 2020, 53.30,  0.38,  0.50,  3.40, 72.30),
('KEN', 2000, 60.10,  0.14,  1.40,  4.90, 46.00),
('KEN', 2010, 42.60,  0.20,  1.40,  5.70, 61.90),
('KEN', 2020, 28.90,  0.24,  1.40,  5.00, 74.20);
