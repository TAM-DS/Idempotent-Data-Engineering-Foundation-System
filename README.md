# End-to-End Data Pipeline & Mart Architecture
### From Raw CSV to Market Intelligence — Built and Deployed With One Command

> *"The data doesn't lie. But only if the architecture is honest first."*

[Project Scope](https://github.com/TAM-DS/SQL_Data_Engineering_Projects/blob/main/Images/project%20Scope.jpg)
---

## 🚀 One Command. Entire Platform.

```bash
duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
```

That single command builds everything — the data warehouse, all dimension and fact tables, every data mart, batch updates, and validation checks. From zero to production in under 60 seconds.

**This is what idempotent architecture looks like in practice.**

---

## 🦆 Connect To The Live Database

```sql
ATTACH 'md:_share/dw_marts/05413662-8da3-4400-a371-4f2258399608';
```

Grab a free [MotherDuck](https://motherduck.com) account, run this line, and you're connected to the live platform instantly. No setup. No infrastructure. Just query.

---

## The Architecture

![Project Scope]()

The platform moves data through four clearly defined layers:

**Data Storage → Data Warehouse → Data Marts → Data Serving**

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Data Storage | Google Cloud Storage | Source CSV files hosted at scale |
| Data Warehouse | DuckDB + MotherDuck | Star schema — the single source of truth |
| Data Marts | DuckDB Schemas | Purpose-built analytical layers |
| Data Serving | Excel, Power BI, Tableau, Python | Downstream consumption |

---

## The Data Warehouse — Star Schema

![Data Warehouse Schema](images/Data-Warehouse_1.jpg)

Built on a classic star schema with one central fact table and three dimension tables — optimized for analytical queries, not transactional operations.

### Tables

| Table | Type | Records | Description |
|-------|------|---------|-------------|
| `job_postings_fact` | Fact | 1,615,930 | Core job posting data — the center of the star |
| `company_dim` | Dimension | 215,940 | Company profiles across 20 countries |
| `skills_dim` | Dimension | 262 | Unique skills with type classification |
| `skills_job_dim` | Bridge | 7,193,426 | Many-to-many skill-to-job relationships |

**Total: 9,025,356 rows of real market data.**

### Why Star Schema

Star schema was chosen deliberately over snowflake for this project:

- Simpler joins mean faster analytical queries
- Easier for downstream consumers (Power BI, Tableau, Python) to navigate
- Denormalization is acceptable here — this is a read-heavy analytical platform, not a transactional system
- Better alignment with how MotherDuck and DuckDB optimize query execution

---

## The Master Build Script

The entire platform is built and rebuilt by a single idempotent master script:

```bash
duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
```

### What Idempotent Means Here

Every script uses `DROP ... IF EXISTS` and `CREATE OR REPLACE` patterns. Run it once — you get the platform. Run it again — you get the same platform, clean. No manual teardown. No state management. No surprises.

This is production-grade pipeline thinking applied to a portfolio project.

### Build Order

```sql
-- MASTER BUILD SCRIPT
-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1: Build the data warehouse star schema
.read 01_create_tables_dw.sql

-- Step 2: Load data from Google Cloud Storage CSVs
.read 02_load_schema_dw.sql

-- Step 3: Build the flat mart
.read 03_create_flat_mart.sql

-- Step 4: Build the skills demand mart
.read 04_create_skills_mart.sql

-- Step 5: Build the priority mart
.read 05_create_priority_mart.sql

-- Step 6: Run batch updates for priority mart
.read 06_batch_updates_priority_mart.sql
```

### Why This Order Matters

Foreign key constraints enforce referential integrity throughout the pipeline. Dimension tables must exist before fact tables. Fact tables must be populated before marts. The build order is not arbitrary — it reflects the dependency graph of the entire platform.

---

## The Data Pipeline

### Step 1 — Schema Creation (`01_create_tables_dw.sql`)

Creates the star schema with full constraint enforcement:

- Primary keys on all dimension tables
- Foreign keys linking fact table to dimensions
- Composite primary keys on the bridge table
- Data types optimized for analytical workloads

**Key design decision:** A `skill_id = 0` sentinel row was added to `skills_dim` to handle job postings with no associated skills — preventing foreign key violations without losing data.

```sql
INSERT INTO skills_dim (skill_id, skills, type)
SELECT 0, 'Unknown', 'Unknown'
WHERE NOT EXISTS (
    SELECT 1 FROM skills_dim WHERE skill_id = 0
);
```

This is the difference between a pipeline that breaks on edge cases and one that handles reality.

### Step 2 — Data Loading (`02_load_schema_dw.sql`)

All source data loads directly from Google Cloud Storage via URL — no local files required:

```sql
INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=TRUE);
```

**Validation after every load:**

```sql
SELECT 'Company Dim' AS table_name, COUNT(*) AS record_count FROM company_dim
UNION ALL
SELECT 'Skills Dim', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Dim', COUNT(*) FROM skills_job_dim;
```

Expected output:

```
┌───────────────────┬──────────────┐
│ Company Dim       │       215940 │
│ Skills Dim        │          262 │
│ Job Postings Fact │      1615930 │
│ Skills Job Dim    │      7193426 │
└───────────────────┴──────────────┘
```

### Step 3 — Flat Mart (`03_create_flat_mart.sql`)

A denormalized flat table joining all dimensions to the fact table — optimized for direct consumption by Excel, Power BI, and Python without requiring join logic from the consumer.

**Output:** 1,615,930 rows with all company, skill, and posting attributes in a single queryable surface.

### Step 4 — Skills Demand Mart (`04_create_skills_mart.sql`)

A purpose-built analytical mart with its own star schema:

- `skills_mart.dim_skills` — 262 skills
- `skills_mart.dim_date_month` — 30 months (2023 Q1 → 2025 Q2)
- `skills_mart.fact_skill_demand_monthly` — 52,520 rows of monthly skill demand

**What makes this mart powerful:** Time series analysis. Every skill tracked monthly across 30 months, segmented by job role, with remote work, health insurance, and degree requirement flags.

```sql
-- Boolean flags converted to integers for aggregation
CASE WHEN jpf.job_work_from_home = TRUE THEN 1 ELSE 0 END AS is_remote,
CASE WHEN jpf.job_health_insurance = TRUE THEN 1 ELSE 0 END AS has_health_insurance,
CASE WHEN jpf.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_mentioned
```

### Step 5 — Priority Mart (`05_create_priority_mart.sql`)

A role-priority snapshot mart that tracks high-value engineering roles with configurable priority levels:

```
┌──────────────────────┬───────────┬──────────────┐
│ Data Engineer        │   391,957 │ Priority 1   │
│ Data Scientist       │   331,002 │ Priority 3   │
│ Software Engineer    │    92,271 │ Priority 3   │
│ Senior Data Engineer │    91,295 │ Priority 1   │
└──────────────────────┴───────────┴──────────────┘
```

### Step 6 — Batch Updates (`06_batch_updates_priority_mart.sql`)

A MERGE-based batch update pattern that upserts new roles and updates priority levels without full rebuilds:

```sql
MERGE INTO priority_mart.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id
WHEN MATCHED THEN UPDATE SET ...
WHEN NOT MATCHED THEN INSERT ...
```

This is enterprise-grade SCD (Slowly Changing Dimension) thinking applied to a job market platform.

---

## Data Validation

Every script emits validation output. Nothing runs silently.

```
100% ▕██████████████████████████████████████▏ (00:00:04.78 elapsed)
┌───────────────────┬──────────────┐
│ Job Postings Fact │      1615930 │
│ Skills Job Dim    │      7193426 │
└───────────────────┴──────────────┘
```

Clean runs. Full counts. Visible progress. Every time.

---

## Project Structure

```
2_Pipeline_ETL/
├── build_dw_marts.sql              # Master build script — run this
├── 01_create_tables_dw.sql         # Star schema DDL
├── 02_load_schema_dw.sql           # Data pipeline from GCS
├── 03_create_flat_mart.sql         # Flat analytical mart
├── 04_create_skills_mart.sql       # Skills demand mart
├── 05_create_priority_mart.sql     # Priority roles mart
├── 06_batch_updates_priority_mart.sql  # MERGE batch updates
└── images/
    ├── Data-Warehouse_1.jpg        # Star schema diagram
    └── project_Scope.jpg           # Full pipeline architecture
```

---

## Tech Stack

| Technology | Role |
|-----------|------|
| DuckDB | Local query engine and database |
| MotherDuck | Cloud hosting and live sharing |
| Google Cloud Storage | Source data hosting |
| SQL | Pipeline, transformation, and analysis |
| Star Schema | Warehouse design pattern |
| MERGE / Upsert | Batch update strategy |

---

## Key Engineering Decisions

**Star over snowflake** — Simpler joins, better performance for analytical workloads, easier downstream consumption.

**Median over average** — Salary averages are distorted by outliers. Median tells the truth.

**Logarithmic demand scaling** — Prevents high-volume skills from dominating optimal scoring. Finds true salary × demand balance.

**Sentinel row for nulls** — `skill_id = 0` handles missing skills without data loss or pipeline failure.

**Idempotent design** — Every script can be rerun safely. No manual teardown required.

**One command deployment** — The entire platform builds from a single terminal command. This is not accidental — it's a deliberate architectural choice.

---

## Want To See What The Data Reveals?

→ **[EDA & Findings Repo](#)** — The three SQL findings built on this platform: top demanded skills, highest paying skills, and the optimal salary × demand intersection.

---

*Built by Tracy Manning | [Apex ML Engineering](https://github.com/TAM-DS) | Principal Architect*

*"Architecture isn't what you build. It's what you never have to rebuild."*
