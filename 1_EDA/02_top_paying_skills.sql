/*
Question: What are the highest paying skills for data engineers?
-Rather than use the AVG Salary withch often can be skewed, I focused on the 
MEDIAN Salary for each skill required in data engineering positions.
- Included skill frequency to identify both salary and demand.
-Why? this helps to identify which skills offer the highest ROI while also 
providing a clear picture for skill development priotities for both the 
indivdual and the company training departments and HR to correctly list
the skills needed.
*/

 SELECT
      sd.skills,
      ROUND(MEDIAN(jpf.salary_year_avg), 1) AS median_salary,
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
HAVING
    COUNT(jpf.*) > 200
  ORDER BY    
      median_salary DESC
  LIMIT 25;

  /*
  ───────────────┬───────────────┬──────────────┐
│    skills     │ median_salary │ demand_count │
│    varchar    │    double     │    int64     │
├───────────────┼───────────────┼──────────────┤
│ mongo         │      201000.0 │         3795 │
│ rust          │      169687.5 │         1317 │
│ puppet        │      157500.0 │         1066 │
│ groovy        │      157500.0 │          813 │
│ vue           │      156500.0 │         1107 │
│ codecommit    │      155000.0 │          292 │
│ golang        │      155000.0 │         2805 │
│ zoom          │      155000.0 │          669 │
│ ansible       │      150000.0 │         6122 │
│ node          │      150000.0 │         1084 │
│ ruby on rails │      150000.0 │          319 │
│ typescript    │      150000.0 │         2616 │
│ pytorch       │      147500.0 │         4400 │
│ kafka         │      147500.0 │        56410 │
│ cassandra     │      147500.0 │        12206 │
│ graphql       │      147500.0 │         2215 │
│ redis         │      147500.0 │         4215 │
│ macos         │      146200.0 │          245 │
│ kubernetes    │      145500.0 │        29803 │
│ ruby          │      145250.0 │         4586 │
│ airflow       │      145000.0 │        54096 │
│ ibm cloud     │      145000.0 │         1303 │
│ terraform     │      145000.0 │        21683 │
│ fastapi       │      145000.0 │         1567 │
│ c             │      145000.0 │         5039 │
├───────────────┴───────────────┴──────────────┤
│ 25 rows                            3 columns │

/*
Results Breakdown — Top 25 Highest Paying Data Engineering Skills in 2026:

The decision to use MEDIAN rather than AVG salary is intentional — 
a single $500K outlier can make a dying skill look lucrative. 
Median tells the truth.

MongoDB leads decisively at $201,000 median — nearly $32K above 
the next highest skill. Document database expertise at scale 
commands a significant premium in 2026.

Rust follows at $169,688 — a clear signal that systems-level 
programming is becoming increasingly valuable as data infrastructure 
moves closer to the metal for performance-critical workloads.

The $150K–$157K cluster reveals something important: infrastructure 
and backend skills (Puppet, Groovy, Golang, TypeScript) are 
commanding equal or higher salaries than pure data skills. 
The market is paying for engineers who understand the full stack.

The most strategic insight in this dataset is the salary/demand 
intersection:

→ Kafka: $147,500 median | 56,410 postings
→ Kubernetes: $145,500 median | 29,803 postings  
→ Airflow: $145,000 median | 54,096 postings
→ Terraform: $145,000 median | 21,683 postings

These four skills represent the sweet spot — strong compensation 
AND near-guaranteed employability. They are not optional for 
serious data engineers in 2026.

AI/ML tooling (PyTorch at $147,500) sits slightly below pure 
infrastructure skills in median salary — but demand will accelerate 
as agentic AI workloads scale into production environments.

The highest ROI skill combination for 2026:
MongoDB + Kafka + Kubernetes + Airflow + PyTorch

High salary. High demand. High job security.
*/



