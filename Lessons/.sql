SELECT
    column_name,
    table_name,
    data_type
FROM
    information_schema.columns
WHERE table_name = 'job_postings_fact';

SELECT 
    CAST(123 AS VARCHAR);

SELECT 

    CAST(job_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR), -- idea to combine with job id to get a unique identifies
    CAST(job_work_from_home AS INT),--from bool to numerica value
    CAST(job_posted_date AS DATE), --from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10,0))-- from double to no decimal places
FROM
    job_postings_fact 
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

SELECT 

    job_id :: VARCHAR || '-' || company_id :: VARCHAR, -- idea to combine with job id to get a unique identifies
    job_work_from_home :: INT,--from bool to numerica value
    job_posted_date :: DATE, --from timestamp to date only
    salary_year_avg :: DECIMAL(10,0) -- from double to no decimal places
FROM
    job_postings_fact 
WHERE salary_year_avg IS NOT NULL
LIMIT 10;

-- query to count the number of job postings for the date dec 31, 2024

SELECT
    jpf.job_posted_date::Date as dt,
    count(job_id) AS job_postings 
FROM
    job_postings_fact AS jpf 
WHERE jpf.job_posted_date::Date = '2024-12-24'
GROUP BY dt;

-- run a query too group jobs posted in dec converting bool into int for grouping

SELECT  
    jpf.job_title_short,
    jpf.job_no_degree_mention::INT AS job_no_degree_mention,
    count(job_id) 
FROM
    job_postings_fact AS jpf
WHERE
    job_posted_date::DATE BETWEEN '2024-12-01' AND '2024-12-31'
GROUP BY 
    jpf.job_title_short,
    jpf.job_no_degree_mention
ORDER BY
    jpf.job_title_short,
    jpf.job_no_degree_mention;