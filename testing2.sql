SHOW DATABASES;

CREATE DATABASE IF NOT EXISTS job_mart;

DROP DATABASE job_mart;

SELECT
    *
FROM
    information_schema.schemata;

USE job_mart;



CREATE SCHEMA job_mart.staging;

CREATE TABLE staging.priority_roles (
    role_id INTEGER,
    role_name VARCHAR
);

SELECT  
    *
FROM
    information_schema.tables
WHERE
    table_catalog = 'job_mart';


DROP TABLE main.priority_roles;