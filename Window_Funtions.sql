SELECT
    count(*)
FROM
    job_postings_fact;
---NOw ith Windows Function OVER () 

SELECT
    job_id,
    COUNT(*) OVER ()
FROM
    job_postings_fact
LIMIT 20;


--PARTITION BY

SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short, company_id
    )
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY
    RANDOM()
LIMIT 10;
--Order BY

SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK () OVER(
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_avg
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL
ORDER BY
    salary_hour_avg DESC
LIMIT 30;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK () OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC
    ) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL 
ORDER BY
    salary_hour_avg DESC,
    job_title_short
LIMIT 10;