--UNION combines and removes the dublicates
SELECT UNNEST ([1,1,2,1,2,1])
UNION 
SELECT UNNEST ([1,2,2,2,1]);

SELECT UNNEST ([1,3,4,2,5,6,4,1])
UNION
SELECT UNNEST ([2,1,3,4,2,1,4,]);
--Union ALL function retiurns all
SELECT UNNEST ([1,3,4,2,5,6,4,1])
UNION ALL
SELECT UNNEST ([2,1,3,4,2,1,4,]);

--Intesect returns rows that are common removes all dublicates - % & ^ are not included because not common
SELECT UNNEST ([1,3,4,2,5,6,4,1])
INTERSECT
SELECT UNNEST ([2,1,3,4,2,1,4,]);

SELECT UNNEST ([1,3,4,2,5,6,4,1])
INTERSECT ALL --no duplicates removed but still only common to both rows ie, 5 & 6 not included
SELECT UNNEST ([2,1,3,4,2,1,4,]);

SELECT UNNEST ([1,3,4,2,5,6,4,1])
EXCEPT --EXCEPT table A only 
SELECT UNNEST ([2,1,3,4,2,1,4,]);

SELECT UNNEST ([1,3,4,2,5,6,4,1])
EXCEPT ALL
SELECT UNNEST ([2,1,3,4,2,1,4,]);


CREATE TEMP Table jobs_2023 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT (YEAR FROM job_posted_date) = 2023;

SELECT * FROM jobs_2024
LIMIT 20;

CREATE TEMP Table jobs_2024 AS
SELECT * EXCLUDE (job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT (YEAR FROM job_posted_date) = 2024;



SELECT 
'jobs_2023' AS table_name,
    COUNT (*) AS record_count
FROM jobs_2023
EXCEPT
SELECT 
    'jobs_2024' AS table_name,
    COUNT (*) 
FROM jobs_2024;

--which jobs appeard in 2023 but not 2024
SELECT * FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

SELECT * FROM jobs_2023
EXCEPT ALL -- which h=jobs remain after subtracting from 2024 0ne for one?
SELECT * FROM jobs_2024;

SELECT * FROM jobs_2023
INTERSECT-- which jobs appear in both 2023 and 2024
SELECT * FROM jobs_2024;