# 🦆 End-to-End Data Pipeline & Mart Architecture
### From Raw CSV to Market Intelligence — Built and Deployed With One Command

<p align="center">
  <img src="https://img.shields.io/badge/DuckDB-0.10+-FFF000?style=for-the-badge&logo=duckdb&logoColor=black" />
  <img src="https://img.shields.io/badge/MotherDuck-Cloud_Ready-00B4D8?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Rows_Processed-9%2C025%2C356-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Deploy-1_Command-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Schema-Star-blueviolet?style=for-the-badge" />
  <img src="https://img.shields.io/badge/License-MIT-lightgrey?style=for-the-badge" />
</p>

<p align="center">
  <img src="Images/project%20Scope.jpg" alt="Full Pipeline Architecture" width="85%"/>
</p>

---

> *"Every model is only as intelligent as the data beneath it. Every dashboard only as honest as the architecture behind it. I've seen million-dollar decisions made on corrupted data — nobody questioned the dashboard, they should have questioned the pipeline."*

---

## ⚡ One Command. Entire Platform.

```bash
duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
```

That single command builds everything — the data warehouse, all dimension and fact tables, every data mart, batch updates, and validation checks. **From zero to production in under 60 seconds.**

This is what idempotent architecture looks like in practice.

---

## 🚀 Free Tier Quickstart — Query Live Data in 2 Minutes

No installs. No infrastructure. No credit card.

**Step 1 — Get a free MotherDuck account**

→ Go to [motherduck.com](https://motherduck.com) and sign up for free (takes 30 seconds)

**Step 2 — Open the MotherDuck SQL editor and run this single line**

```sql
ATTACH 'md:_share/dw_marts/05413662-8da3-4400-a371-4f2258399608';
```

**Step 3 — You're in. Start querying 9 million rows of live job market data.**

```sql
-- What are the top 10 most demanded skills in the market right now?
SELECT
    sd.skills,
    COUNT(*) AS demand_count
FROM dw_marts.job_postings_fact jpf
JOIN dw_marts.skills_job_dim sjd ON jpf.job_id = sjd.job_id
JOIN dw_marts.skills_dim sd ON sjd.skill_id = sd.skill_id
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 10;
```

> **That's it.** You're connected to a production-grade star schema data warehouse with 9M+ rows — live, shared, and free to explore.

---

## 🏗️ The Architecture

Data moves through four clearly defined layers — no shortcuts, no cowboy transformations:

```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│   SOURCE              WAREHOUSE            MARTS           SERVING  │
│                                                                      │
│  CSV Files    ───►   Star Schema   ───►   Flat Mart   ───►  Excel   │
│  (GCS URLs)          DuckDB /             Skills Mart      Power BI │
│                      MotherDuck           Priority Mart    Tableau  │
│                                                            Python   │
└──────────────────────────────────────────────────────────────────────┘
```

| Layer | Technology | Purpose |
|---|---|---|
| **Data Storage** | Google Cloud Storage | Source CSV files — no local dependencies |
| **Data Warehouse** | DuckDB + MotherDuck | Star schema — the single source of truth |
| **Data Marts** | DuckDB Schemas | Purpose-built analytical layers |
| **Data Serving** | Excel · Power BI · Tableau · Python | Downstream consumption without join logic |

---

## 🌟 The Data Warehouse — Star Schema

Classic star schema. One central fact table. Three dimension tables. Optimized for analytical queries — not transactions.

```
                        ┌──────────────────┐
                        │   company_dim    │
                        │  (215,940 rows)  │
                        └────────┬─────────┘
                                 │
          ┌──────────────────────▼──────────────────────┐
          │              job_postings_fact               │
          │               (1,615,930 rows)               │
          │         ◄── Center of the Star ──►           │
          └────────────────┬───────────────────────────-─┘
                           │
          ┌────────────────┴──────────────────────┐
          │                                       │
 ┌────────▼─────────┐                 ┌──────────▼──────────┐
 │   skills_dim     │◄────────────────│   skills_job_dim    │
 │   (262 rows)     │                 │   (7,193,426 rows)  │
 └──────────────────┘                 └─────────────────────┘
```

| Table | Type | Records | Description |
|---|---|---|---|
| `job_postings_fact` | **Fact** | 1,615,930 | Core job posting data — the center of the star |
| `company_dim` | **Dimension** | 215,940 | Company profiles across 20 countries |
| `skills_dim` | **Dimension** | 262 | Unique skills with type classification |
| `skills_job_dim` | **Bridge** | 7,193,426 | Many-to-many skill-to-job relationships |

**Total: 9,025,356 rows of real market data.**

### Why Star Schema Over Snowflake

Star schema was the deliberate choice here — not the default:

- **Simpler joins** → faster analytical queries at 9M+ row scale
- **Easier downstream access** — Power BI, Tableau, and Python consumers navigate without DBA support
- **Denormalization is appropriate** — this is a read-heavy analytical platform, not a transactional system
- **Better alignment** with how DuckDB and MotherDuck optimize query execution

---

## 🔧 The Master Build Script

```bash
duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
```

### What Idempotent Means Here

Every script uses `DROP ... IF EXISTS` and `CREATE OR REPLACE` patterns.

Run it once — you get the platform.
Run it again — you get the **same** platform, clean.

No manual teardown. No state management. No surprises. **This is how production pipelines should behave.**

### Build Order & Why It Matters

```sql
-- MASTER BUILD SCRIPT
-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

.read 01_create_tables_dw.sql               -- Step 1: Star schema DDL with FK constraints
.read 02_load_schema_dw.sql                 -- Step 2: Load 9M+ rows from GCS via URL
.read 03_create_flat_mart.sql               -- Step 3: Denormalized flat mart for BI tools
.read 04_create_skills_mart.sql             -- Step 4: Skills demand mart with time series
.read 05_create_priority_mart.sql           -- Step 5: Priority roles snapshot mart
.read 06_batch_updates_priority_mart.sql    -- Step 6: MERGE-based upserts
```

Foreign key constraints enforce referential integrity throughout. Dimension tables must exist before fact tables. Fact tables before marts. **The build order reflects the dependency graph of the entire platform** — not an arbitrary sequence.

---

## 📦 Pipeline Deep Dive

### Step 1 — Schema Creation (`01_create_tables_dw.sql`)

Full constraint enforcement from day one:

- Primary keys on all dimension tables
- Foreign keys linking fact table to dimensions
- Composite primary keys on the bridge table
- Data types optimized for analytical workloads

**Key engineering decision:** A `skill_id = 0` sentinel row handles job postings with no associated skills — preventing FK violations without data loss.

```sql
INSERT INTO skills_dim (skill_id, skills, type)
SELECT 0, 'Unknown', 'Unknown'
WHERE NOT EXISTS (
    SELECT 1 FROM skills_dim WHERE skill_id = 0
);
```

This is the difference between a pipeline that breaks on edge cases and one that handles reality.

---

### Step 2 — Data Loading (`02_load_schema_dw.sql`)

Source data loads directly from Google Cloud Storage via URL. **No local files required.**

```sql
INSERT INTO company_dim (company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=TRUE);
```

Validation runs after every load:

```sql
SELECT 'Company Dim'        AS table_name, COUNT(*) AS record_count FROM company_dim
UNION ALL
SELECT 'Skills Dim',        COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Dim',    COUNT(*) FROM skills_job_dim;
```

Expected output — every time:

```
┌───────────────────┬──────────────┐
│ Company Dim       │       215940 │
│ Skills Dim        │          262 │
│ Job Postings Fact │      1615930 │
│ Skills Job Dim    │      7193426 │
└───────────────────┴──────────────┘
```

---

### Step 3 — Flat Mart (`03_create_flat_mart.sql`)

A fully denormalized surface joining all dimensions to the fact table. Downstream consumers in Excel, Power BI, and Python query this directly — **no join logic required from the consumer**.

**Output:** 1,615,930 rows. Everything in one queryable surface.

---

### Step 4 — Skills Demand Mart (`04_create_skills_mart.sql`)

Purpose-built mart with its own star schema inside the `skills_mart` schema:

| Table | Records | Description |
|---|---|---|
| `skills_mart.dim_skills` | 262 | All unique skills |
| `skills_mart.dim_date_month` | 30 | Monthly buckets: 2023 Q1 → 2025 Q2 |
| `skills_mart.fact_skill_demand_monthly` | 52,520 | Monthly skill demand by role |

**What makes this mart powerful:** Every skill tracked monthly across 30 months, segmented by job role, with remote work, health insurance, and degree requirement flags.

```sql
CASE WHEN jpf.job_work_from_home = TRUE THEN 1 ELSE 0 END    AS is_remote,
CASE WHEN jpf.job_health_insurance = TRUE THEN 1 ELSE 0 END  AS has_health_insurance,
CASE WHEN jpf.job_no_degree_mention = TRUE THEN 1 ELSE 0 END AS no_degree_mentioned
```

Boolean flags cast to integers — aggregatable without CASE logic downstream.

---

### Step 5 — Priority Mart (`05_create_priority_mart.sql`)

A role-priority snapshot mart tracking high-value engineering roles with configurable priority tiers:

```
┌──────────────────────────┬────────────┬──────────────┐
│ Data Engineer            │    391,957 │  Priority 1  │
│ Data Scientist           │    331,002 │  Priority 3  │
│ Software Engineer        │     92,271 │  Priority 3  │
│ Senior Data Engineer     │     91,295 │  Priority 1  │
└──────────────────────────┴────────────┴──────────────┘
```

---

### Step 6 — Batch Updates (`06_batch_updates_priority_mart.sql`)

MERGE-based upsert pattern. New roles insert. Existing roles update. **No full rebuilds.**

```sql
MERGE INTO priority_mart.priority_jobs_snapshot AS tgt
USING src_priority_jobs AS src
ON tgt.job_id = src.job_id
WHEN MATCHED THEN
    UPDATE SET priority_level = src.priority_level, ...
WHEN NOT MATCHED THEN
    INSERT (job_id, title, priority_level, ...) VALUES (...);
```

Enterprise-grade SCD (Slowly Changing Dimension) thinking applied to a job market platform.

---

## ✅ Data Validation — Nothing Runs Silently

Every script emits validation output. Progress bars. Row counts. Explicit confirmation at every stage.

```
100% ▕████████████████████████████████████▏ (00:00:04.78 elapsed)

┌───────────────────┬──────────────┐
│ Job Postings Fact │      1615930 │
│ Skills Job Dim    │      7193426 │
└───────────────────┴──────────────┘
```

If the numbers don't match, you know immediately — not three steps later.

---

## 📁 Project Structure

```
SQL_Data_Engineering_Projects/
│
├── 2_Pipeline_ETL/
│   ├── build_dw_marts.sql                    # ← Run this. Builds everything.
│   ├── 01_create_tables_dw.sql               # Star schema DDL
│   ├── 02_load_schema_dw.sql                 # Data pipeline from GCS
│   ├── 03_create_flat_mart.sql               # Flat analytical mart
│   ├── 04_create_skills_mart.sql             # Skills demand mart w/ time series
│   ├── 05_create_priority_mart.sql           # Priority roles snapshot mart
│   └── 06_batch_updates_priority_mart.sql    # MERGE batch upserts
│
├── 1_EDA/
│   └── [Exploratory findings built on this warehouse]
│
└── Images/
    ├── project Scope.jpg                     # Full pipeline architecture
    └── Data-Warehouse_1.jpg                  # Star schema diagram
```

---

## 🛠️ Tech Stack

| Technology | Role |
|---|---|
| **DuckDB** | Local OLAP query engine — zero-infrastructure analytics |
| **MotherDuck** | Cloud hosting, live sharing, and collaborative SQL |
| **Google Cloud Storage** | Source data hosting — URL-based loading, no local files |
| **SQL** | Pipeline orchestration, transformation, and analysis |
| **Star Schema** | Warehouse design pattern — deliberate over snowflake |
| **MERGE / Upsert** | Incremental batch update strategy |
| **Idempotent Design** | Safe reruns — no teardown, no surprises |

---

## 🎯 What This Demonstrates

This isn't a tutorial project. It's a **production-grade data platform** built with the same principles used at scale:

| Principle | Implementation |
|---|---|
| **Idempotency** | Every script safe to rerun. `DROP IF EXISTS` + `CREATE OR REPLACE` throughout. |
| **Referential Integrity** | FK constraints enforced at schema level — not just in application logic. |
| **Edge Case Handling** | Sentinel rows absorb nulls without data loss or pipeline failure. |
| **Incremental Loads** | MERGE-based upserts avoid expensive full rebuilds on update cycles. |
| **Analytical Design** | Star schema chosen deliberately — simpler joins, faster queries, easier downstream. |
| **Observability** | Validation output at every stage. Nothing runs silently. |
| **One-Command Deploy** | Entire platform builds from a single terminal command. Repeatable. Always. |

---

## 🔑 Key Engineering Decisions

**Star over snowflake** — Simpler joins, better performance for analytical workloads, easier for BI consumers who don't want to write five-table joins.

**Median over average** — Salary averages are distorted by outliers. Median tells the truth.

**Logarithmic demand scaling** — Prevents high-volume skills from dominating optimal scoring. Finds the true salary × demand intersection.

**Sentinel row for nulls** — `skill_id = 0` absorbs missing skill associations without data loss or FK violations.

**URL-based data loading** — Source data loads from GCS directly. No local file dependencies. Runs anywhere DuckDB runs.

**One-command deploy** — Not a convenience feature. A deliberate signal about how production pipelines should be built and handed off.

**Finding-neutral by design** — The warehouse carries no embedded conclusions. Every mart and analytical layer is architected to support any question, not just the ones I asked. Salary, demand, role priority, time series — the platform serves the analyst's lens, not the builder's opinion.

---

## 📊 Want To See What The Data Reveals?

This warehouse powers three analytical findings:

- 🥇 **Top demanded skills** — What the market is actually hiring for
- 💰 **Highest paying skills** — Where compensation concentrates
- 📈 **Optimal skills** — The salary × demand intersection that no spreadsheet will show you

→ **[Explore the EDA & Findings](./1_EDA)**

---

## 📜 License

MIT — Use it, fork it, build on it. Attribution appreciated.

---

<p align="center">
  Built by <strong>Tracy Manning</strong> &nbsp;|&nbsp; Principal Architect &nbsp;|&nbsp;
  <a href="https://github.com/TAM-DS">Apex ML Engineering</a>
</p>

<p align="center">
  <em>"Architecture isn't what you build. It's what you never have to rebuild."</em>
</p>
