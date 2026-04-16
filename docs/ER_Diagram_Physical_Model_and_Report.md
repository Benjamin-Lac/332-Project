# World Database Project Deliverables

## Part A: ER Diagram

```mermaid
erDiagram
    COUNTRY ||--o{ CITY : has
    COUNTRY ||--o{ COUNTRYLANGUAGE : speaks
    CITY o|--|| COUNTRY : capital_of

    COUNTRY ||--o{ COUNTRY_ORGANIZATION_MEMBERSHIP : joins
    INTERNATIONAL_ORGANIZATION ||--o{ COUNTRY_ORGANIZATION_MEMBERSHIP : contains
    COUNTRY ||--o{ COUNTRY_GDP_HISTORY : tracks
    COUNTRY ||--|| CLIMATE_RISK_ASSESSMENT : assessed_by
    COUNTRY ||--o{ INTERNATIONAL_ORGANIZATION : hosts_hq

    COUNTRY {
        char(3) Code PK
        varchar Name
        varchar Continent
        varchar Region
        decimal SurfaceArea
        int Population
        int Capital FK
        char(2) Code2
    }

    CITY {
        int ID PK
        varchar Name
        char(3) CountryCode FK
        varchar District
        int Population
    }

    COUNTRYLANGUAGE {
        char(3) CountryCode PK, FK
        varchar Language PK
        char(1) IsOfficial
        decimal Percentage
    }

    INTERNATIONAL_ORGANIZATION {
        int organization_id PK
        varchar organization_name UK
        date founded_date
        char(3) headquarters_country_code FK
    }

    COUNTRY_ORGANIZATION_MEMBERSHIP {
        int membership_id PK
        char(3) country_code FK
        int organization_id FK
        date joined_date
        varchar membership_status
    }

    COUNTRY_GDP_HISTORY {
        char(3) country_code PK, FK
        smallint record_year PK
        decimal gdp_usd_billion
        decimal gdp_growth_pct
    }

    CLIMATE_RISK_ASSESSMENT {
        char(3) country_code PK, FK
        decimal risk_score
        varchar risk_level
        date assessed_on
    }
```

## Part A: Physical Model

Physical SQL model is implemented in:
- `/home/runner/work/332-Project/332-Project/sql/world_physical_model.sql`

Additional seed data is implemented in:
- `/home/runner/work/332-Project/332-Project/sql/additional_data.sql`

### Integrity Constraints Included
- Primary keys on all entities
- Foreign keys across base and added tables
- `NOT NULL` constraints on required columns
- Date constraints (`founded_date < CURRENT_DATE`, `joined_date < CURRENT_DATE`, `assessed_on <= CURRENT_DATE`)
- Domain constraints (`risk_level`, `membership_status`, `IsOfficial`, percentages in valid ranges)

## Part B: 20 Innovative Queries

All 20 queries are in:
- `/home/runner/work/332-Project/332-Project/sql/part_b_queries.sql`

### Query distribution
- Join-based queries: **Q1–Q10** (10 queries)
- Subquery-based queries: **Q11–Q20** (10 queries)

### Notes for execution
1. Load base world schema/data from your class-provided script.
2. Run `/sql/world_physical_model.sql`.
3. Run `/sql/additional_data.sql`.
4. Run `/sql/part_b_queries.sql`.

Each query is designed to include base world tables and added project tables across the full set and is expected to return multiple rows with standard world sample data.
