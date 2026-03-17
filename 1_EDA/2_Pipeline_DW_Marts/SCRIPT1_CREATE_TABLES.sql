-- .read SCRIPT1_CREATE_TABLES.sql

USE data_jobs;

DROP DATABASE IF EXISTS job_mart;

CREATE DATABASE IF NOT EXISTS job_mart;

SHOW DATABASES;

SELECT 
    *
FROM 
    information_schema.schemata;

USE
    job_mart;
CREATE SCHEMA IF NOT EXISTS staging;

CREATE TABLE IF NOT EXISTS staging.priority_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);

SELECT  
    *
FROM 
    information_schema.tables
WHERE
    table_catalog = 'job_mart';

INSERT INTO staging.priority_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');
    

ALTER TABLE staging.priority_roles
ADD COLUMN priority_role BOOLEAN;

UPDATE staging.priority_roles 
SET priority_role = TRUE
WHERE role_id = 1 OR role_id = 2;

UPDATE staging.priority_roles
SET priority_role = FALSE
WHERE role_id = 3;

ALTER TABLE staging.priority_roles
RENAME COLUMN priority_role TO priority_lvl;

ALTER TABLE staging.priority_roles
ALTER COLUMN priority_lvl TYPE INTEGER;

UPDATE staging.priority_roles 
SET priority_lvl = 3
WHERE role_id = 3;




SELECT 
    *
FROM
    staging.priority_roles;