--MASTER BUILD SCRIPT 

-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1 DW - Create star schema tables
.read 01_create_tables_dw.sql 

-- STEP 2 DW - Load data from CSV files into tables
.read 02_load_schema_dw.sql 

-- Step 3 Create FLat Mart
.read 03_create_flat_mart.sql

-- Step 4 Create skills demand mart
.read 04_create_skills_mart.sql

-- Step 5 Create Priority Mart
.read 05_create_priority_mart.sql 

--Step 6 Create Batch Updates for Priority Mart
.read 06_batch_updates_priority_mart.sql 
