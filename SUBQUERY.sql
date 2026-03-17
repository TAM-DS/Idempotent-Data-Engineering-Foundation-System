SELECT *
FROM (
   SELECT *
   FROM job_postings_fact 
   WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
LIMIT 10;

--CTE

WITH valid_salaries AS (
SELECT *
   FROM job_postings_fact 
   WHERE salary_year_avg IS NOT NULL
    OR salary_hour_avg IS NOT NULL
)
SELECT *
FROM valid_salaries
LIMIT 10;

-- Show each job's salary next to the overall market median
SELECT
    Job_title_short,
    salary_year_avg,
    (
        SELECT MEDIAN(salary_year_avg)
        FROM job_postings_fact
    ) AS market_median_salary
FROM job_postings_fact 
WHERE salary_year_avg IS NOT NULL
LIMIT 5;
