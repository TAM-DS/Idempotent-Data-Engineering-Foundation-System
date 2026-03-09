/*
Question: What are the most optimal skills for data engineers-balancing bothdemand and salary?
-To identify the most valuable skills created a ranking column that identifies the valuable skill sets.
*/

D  SELECT
        sd.skills,
        ROUND(MEDIAN(jpf.salary_year_avg), 1) AS median_salary,
        COUNT(jpf.*) AS demand_count,
        ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
        ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*))) / 1000000, 2) AS optimal_score
    FROM    
        job_postings_fact AS jpf 
    INNER JOIN skills_job_dim AS sjd 
        ON jpf.job_id =sjd.job_id 
    INNER JOIN skills_dim AS sd 
        ON sjd.skill_id = sd.skill_id 
    WHERE
        jpf.job_title_short = 'Data Engineer'
        AND jpf.salary_year_avg IS NOT NULL
    GROUP BY
        sd.skills
  HAVING
      COUNT(jpf.*) > 100
    ORDER BY    
        optimal_score DESC
    LIMIT 25;

/*

────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ python     │      133000.0 │         7004 │             8.9 │          1.18 │
│ spark      │      140000.0 │         3521 │             8.2 │          1.14 │
│ aws        │      135000.0 │         4406 │             8.4 │          1.13 │
│ sql        │      126010.0 │         7155 │             8.9 │          1.12 │
│ kafka      │      147500.0 │         1991 │             7.6 │          1.12 │
│ mongo      │      201000.0 │          243 │             5.5 │           1.1 │
│ airflow    │      145000.0 │         1618 │             7.4 │          1.07 │
│ java       │      137500.0 │         2469 │             7.8 │          1.07 │
│ hadoop     │      140000.0 │         1951 │             7.6 │          1.06 │
│ scala      │      140000.0 │         1966 │             7.6 │          1.06 │
│ snowflake  │      135000.0 │         2473 │             7.8 │          1.05 │
│ azure      │      126500.0 │         3613 │             8.2 │          1.04 │
│ redshift   │      137500.0 │         1723 │             7.5 │          1.02 │
│ nosql      │      135000.0 │         1641 │             7.4 │           1.0 │
│ kubernetes │      145500.0 │          929 │             6.8 │          0.99 │
│ databricks │      130000.0 │         1783 │             7.5 │          0.97 │
│ terraform  │      145000.0 │          688 │             6.5 │          0.95 │
│ docker     │      139000.0 │          921 │             6.8 │          0.95 │
│ gcp        │      135000.0 │         1180 │             7.1 │          0.95 │
│ cassandra  │      147500.0 │          531 │             6.3 │          0.93 │
│ pyspark    │      135000.0 │          917 │             6.8 │          0.92 │
│ mysql      │      136500.0 │          873 │             6.8 │          0.92 │
│ tableau    │      122500.0 │         1384 │             7.2 │          0.89 │
│ flow       │      130000.0 │          945 │             6.9 │          0.89 │
│ git        │      126884.0 │         1090 │             7.0 │          0.89 │
├────────────┴───────────────┴──────────────┴─────────────────┴───────────────┤
│ 25 rows                                                           5 columns │

/*
Results Breakdown — Most Optimal Data Engineering Skills in 2026:
The Salary × Demand Intersection

Most skill analyses make a critical error — they optimize for either 
salary OR demand. This query does something different.

By applying a logarithmic scale (LN) to demand count, we prevent 
runaway volume from distorting the ranking. A skill with 100,000 
postings shouldn't automatically crush one with 10,000. 
The log scale finds TRUE balance between compensation and marketability.

The result is an optimal_score that identifies the skills worth 
investing in RIGHT NOW.

THE POWER FIVE — Highest Optimal Scores:

→ Python  | $133,000 median | 7,004 postings | Score: 1.18
→ Spark   | $140,000 median | 3,521 postings | Score: 1.14
→ AWS     | $135,000 median | 4,406 postings | Score: 1.13
→ SQL     | $126,010 median | 7,155 postings | Score: 1.12
→ Kafka   | $147,500 median | 1,991 postings | Score: 1.12

These five skills represent the core of every serious data 
engineering role in 2026. Master all five and you are 
essentially recession-proof in this field.

THE SALARY OUTLIER:
MongoDB sits at $201,000 median — the highest paying skill 
in the entire dataset. But with only 243 postings it scores 
1.10 optimal. Extraordinary compensation for those who have 
it. Not a foundation skill — a premium specialization.

THE INFRASTRUCTURE PREMIUM:
Kubernetes ($145,500), Terraform ($145,000), and Docker ($139,000) 
cluster together with strong optimal scores. These aren't data 
skills — they're infrastructure skills. Their presence in the 
top 25 confirms what the market already knows:

The line between data engineer and infrastructure engineer 
is disappearing.

THE STRATEGIC TAKEAWAY:
The optimal stack for 2026 is not a data stack OR an 
infrastructure stack.

It's both.

Python + SQL + Spark + AWS + Kafka + Airflow + Kubernetes + 
Terraform + Docker = the complete AI infrastructure architect.

High demand. Strong salary. Maximum optionality.

That stack doesn't just get you hired.
It gets you hired at the number you asked for.
*/















