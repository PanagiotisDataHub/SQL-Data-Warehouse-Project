/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=========================';
        PRINT 'Loading Silver Layer...';
        PRINT '=========================';

        PRINT '--------------------------';
        PRINT 'Loading CRM Data...';
        PRINT '--------------------------';

        -- Loading silver.crm_cust_info
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;
        PRINT '>>> Inserting Data into silver.crm_cust_info';
            INSERT INTO silver.crm_cust_info (
                cst_id,
                cst_key,
                cst_first_name,
                cst_last_name,
                cst_material_status,
                cst_gndr,
                cst_create_date
            )
            SELECT 
                cst_id,
                cst_key,
                TRIM(cst_first_name) AS cst_first_name,
                TRIM(cst_last_name) AS cst_last_name,
                CASE 
                    WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
                    WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
                    ELSE 'Unknown'
                END AS cst_material_status,
                CASE 
                    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                    ELSE 'Unknown'
                END AS cst_gndr,
                cst_create_date
            FROM(
                SELECT 
                    *,
                    ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS row_num
                FROM
                    bronze.crm_cust_info
                WHERE 
                    cst_id IS NOT NULL
            )t WHERE row_num = 1; -- Retain only the latest record per cst_id
        SET @end_time = GETDATE();
        PRINT '>>> Time Taken to Load silver.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>>--------------------------';

        -- Loading silver.crm_prd_info
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;
        PRINT '>>> Inserting Data into silver.crm_prd_info';
            INSERT INTO silver.crm_prd_info (
                prd_id,
                cat_id,
                prd_key,
                prd_nm,
                prd_cost,
                prd_line,
                prd_start_dt,
                prd_end_dt
            )
            SELECT
                prd_id,
                REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract and format category ID
                SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Extract product key
                prd_nm,
                ISNULL(prd_cost, 0) AS prd_cost,
                CASE UPPER(TRIM(prd_line)) 
                    WHEN 'M' THEN 'Mountain'
                    WHEN 'R' THEN 'Road'
                    WHEN 'T' THEN 'Touring'
                    WHEN 'S' THEN 'Other Sales'
                    ELSE 'Unknown' 
                END AS prd_line, -- Map product line codes to descriptive names
                CAST(prd_start_dt AS DATE) AS prd_start_dt,
                CAST(
                    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 
                    AS DATE
                ) AS prd_end_dt -- Set end date as one day before the next start date
            FROM 
                bronze.crm_prd_info;
        SET @end_time = GETDATE();
        PRINT '>>> Time Taken to Load silver.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>>--------------------------';

        -- Loading silver.crm_sales_details
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;
        PRINT '>>> Inserting Data into silver.crm_sales_details';
            INSERT INTO silver.crm_sales_details (
                sls_ord_num,
                sls_prd_key,
                sls_cust_id,
                sls_order_dt,
                sls_ship_dt,
                sls_due_dt,
                sls_sales,
                sls_quantity,
                sls_price
            )
            SELECT 
                sls_ord_num,
                sls_prd_key,
                sls_cust_id,
                CASE 
                    WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                    ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
                END AS sls_order_dt,  
                CASE 
                    WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                    ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
                END AS sls_ship_dt,
                CASE 
                    WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                    ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
                END AS sls_due_dt,
                CASE 
                    WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity *ABS(sls_price)
                        THEN sls_quantity * ABS(sls_price)
                    ELSE sls_sales
                END AS sls_sales, -- Recalculate sales if inconsistent
                sls_quantity,
                CASE 
                    WHEN sls_price IS NULL OR sls_price <= 0
                        THEN ABS(sls_sales / sls_quantity)
                    ELSE sls_price -- Default to absolute value of sales/quantity if price is invalid
                END AS sls_price
            FROM 
                bronze.crm_sales_details;
        SET @end_time = GETDATE();
        PRINT '>>> Time Taken to Load silver.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>>--------------------------';

        -- Loading erp_cust_az12
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;
        PRINT '>>> Inserting Data into silver.erp_cust_az12';
            INSERT INTO silver.erp_cust_az12 (
                cid, 
                bdate, 
                gen
            )
            SELECT
                CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) --Remove 'NAS' prefix if present
                    ELSE cid 
                END AS cid,
                CASE WHEN bdate > GETDATE() THEN NULL
                    ELSE bdate 
                END AS bdate, -- Set future birthdates to NULL
                CASE 
                    WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                    WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                    ELSE 'Unknown' 
                END AS gen -- Normalize gender values and handle unknowns
            FROM 
                bronze.erp_cust_az12;
        SET @end_time = GETDATE();
        PRINT '>>> Time Taken to Load silver.erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>>--------------------------';

        -- Loading erp_loc_a101
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;
        PRINT '>>> Inserting Data into silver.erp_loc_a101';
            INSERT INTO silver.erp_loc_a101 (
                cid,
                cntry
            )
            SELECT
                REPLACE(cid, '-', '') AS cid,
                CASE 
                    WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                    WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
                    ELSE TRIM(cntry)
                END AS cntry -- Standardize country codes and handle unknowns
            FROM 
                bronze.erp_loc_a101;
        SET @end_time = GETDATE();
        PRINT '>>> Time Taken to Load silver.erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>>--------------------------';

        -- Loading erp_px_cat_g1v2
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        PRINT '>>> Inserting Data into silver.erp_px_cat_g1v2';
            INSERT INTO silver.erp_px_cat_g1v2 (
                id,
                cat,
                subcat,
                maintenance
            )
            SELECT 
                id,
                cat,
                subcat,
                maintenance
            FROM 
                bronze.erp_px_cat_g1v2;
        SET @end_time = GETDATE();
        PRINT '>>> Time Taken to Load silver.erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS VARCHAR) + ' seconds';
        PRINT '>>--------------------------';
    END TRY
        BEGIN CATCH
            PRINT '--------------------------';
            PRINT 'An error occurred while loading the Silver layer.';
            PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR);
            PRINT 'Error Message: ' + ERROR_MESSAGE();
            PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS VARCHAR);
            PRINT 'Error State: ' + CAST(ERROR_STATE() AS VARCHAR);
            PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR);
            PRINT '--------------------------';
        END CATCH
END