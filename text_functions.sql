
-- COUNTS
SELECT LENGTH ('I LOVE YOU');
SELECT CHAR_LENGTH ('SQL');
--Upper and lower
SELECT LOWER ('SQL');
SELECT UPPER ('sql');
--substring extraction
SELECT LEFT ('SQL', 2);
SELECT RIGHT ('SQL',1);
SELECT LEFT ('SQL', 1);
SELECT SUBSTRING ('SQL', 2, 1);
SELECT Concat ('SQL', '-', 'Functions') ;
SELECT  'SQL' || '-' || 'Functions';
SELECT TRIM ('   SQL');

--Replacement Regular
SELECT REPLACE ('SQL', 'Q', '-');

--Replacement REGEX means regular expression
SELECT REGEXP_REPLACE ('tmanning@post.harvard.edu', '^.*@', '\1');

WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM (job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        ELSE 'other'
    END AS job_title_catagory
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;