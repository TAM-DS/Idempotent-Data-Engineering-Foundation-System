-- Load data from our CSV files into the DW tables 


SELECT '=== Loading company_dim Table ===' AS info;

INSERT INTO company_dim(company_id, name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=TRUE);

SELECT '=== Loading skills_dim Table ===' AS info;

INSERT INTO skills_dim (skill_id, skills, type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=TRUE);

-- Insert Unknown after CSV load
INSERT INTO skills_dim (skill_id, skills, type)
SELECT 0, 'Unknown', 'Unknown'
WHERE NOT EXISTS (
    SELECT 1 FROM skills_dim WHERE skill_id = 0
);


SELECT '=== Loading job_posting_fact Table ===' AS info;


INSERT INTO job_postings_fact(job_id, company_id, job_title_short, job_title, job_location, job_via,
job_schedule_type, job_work_from_home, search_location, job_posted_date, job_no_degree_mention, job_health_insurance,
job_country, salary_year_avg, salary_hour_avg
)

SELECT job_id, company_id, job_title_short, job_title, job_location, job_via,
job_schedule_type, job_work_from_home, search_location, job_posted_date, job_no_degree_mention, job_health_insurance,
job_country, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=TRUE);

SELECT '=== Loading skills_job_dim Table ===' AS info;


INSERT INTO skills_job_dim(skill_id, job_id)
SELECT skill_id, job_id 
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT=TRUE);



    SELECT 'Company Dim' AS table_name, COUNT(*) AS record_count FROM company_dim
    UNION ALL
    SELECT 'Skills Dim', COUNT (*) FROM skills_dim;


    SELECT 'Company Dim' AS table_name, COUNT(*) AS record_count FROM company_dim
UNION ALL
SELECT 'Skills Dim', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Dim', COUNT(*) FROM skills_job_dim;

