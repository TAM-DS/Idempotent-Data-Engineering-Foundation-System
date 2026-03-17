SELECT
    table_name,
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'job_postings_fact'
LIMIT 
    20;

--using CAST()

SELECT CAST(123 AS VARCHAR);