
/* What are the most in-demand skills in Data Engineering in 2026
   - Identify the top 10 in-demand skills for Data Engineers
   - Why? This provides insights into the most valuable skills 
     for job seekers and hiring teams alike */


SELECT
    sd.skills,
    COUNT(jpf.*) AS demand_count
FROM    
    job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id =sjd.job_id 
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id 
WHERE
    jpf.job_title_short = 'Data Engineer'
GROUP BY
    sd.skills
ORDER BY    
    demand_count DESC 
LIMIT 10;


/* 
Results Breakdown — Top 10 Data Engineering Skills in 2026:

SQL dominates with 233,132 job postings, confirming that foundational 
query skills remain non-negotiable regardless of how sophisticated 
the stack becomes. Python follows closely at 224,102 postings — 
together these two skills appear in nearly every data engineering 
role globally.

Cloud platforms own the middle tier. AWS leads at 130,205 postings, 
with Azure nearly matching at 128,822 — multi-cloud fluency is now 
a baseline expectation, not a differentiator.

Apache Spark rounds out the top 5 at 106,904 postings, confirming 
that large-scale distributed processing remains central to the role.

The bottom five reveal where the market is heading — Java (69,657), 
Databricks (63,012), Snowflake (60,379), Scala (57,079), and Kafka 
(56,410) — a clear signal that real-time streaming and cloud-native 
platforms are rapidly becoming standard requirements.
*/

────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │       233132 │
│ python     │       224102 │
│ aws        │       130205 │
│ azure      │       128822 │
│ spark      │       106904 │
│ java       │        69657 │
│ databricks │        63012 │
│ snowflake  │        60379 │
│ scala      │        57079 │
│ kafka      │        56410 │
├────────────┴──────────────┤
│ 10 rows         2 columns │
└───────────────────────────┘

*/