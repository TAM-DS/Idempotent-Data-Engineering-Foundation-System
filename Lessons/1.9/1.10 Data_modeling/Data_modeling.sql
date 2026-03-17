SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM
    job_postings_fact
LIMIT 
    10;

SELECT
    company_id,
    name
FROM
    company_dim
LIMIT
    10;



SELECT
    *
FROM
    skills_dim 
LIMIT
    5;

SELECT  
    *
FROM
    Information_schema.tables
WHERE
    table_catalog = 'data_jobs';

