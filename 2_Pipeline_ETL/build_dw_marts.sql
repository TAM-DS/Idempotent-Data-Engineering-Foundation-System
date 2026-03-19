-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"

-- Step 1 DW - Create star schema tables
.read 01_create_tables_dw.sql 

-- STEP 2 DW - Load data from CSV files into tables
.read 02_load_schema_dw.sql 

-- Step 3 Create FLat Mart
.read 03_create_flat_mart.sql