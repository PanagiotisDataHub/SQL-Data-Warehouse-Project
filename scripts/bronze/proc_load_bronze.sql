/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=========================';
        PRINT 'Loading Bronze Layer...';
        PRINT '=========================';

        PRINT '--------------------------';
        PRINT 'Loading CRM Data...';
        PRINT '--------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Bulk inserting data into bronze.crm_cust_info';
            BULK INSERT bronze.crm_cust_info
            FROM 'C:\Users\panos\Documents\Personal\SQL_Data_Warehouse_Project_Local\datasets\source_crm\cust_info.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time = GETDATE();
        PRINT '>> Elapsed time for bronze.crm_cust_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>---------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Bulk inserting data into bronze.crm_prd_info';
            BULK INSERT bronze.crm_prd_info
            FROM 'C:\Users\panos\Documents\Personal\SQL_Data_Warehouse_Project_Local\datasets\source_crm\prd_info.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time = GETDATE();
        PRINT '>> Elapsed time for bronze.crm_prd_info: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>---------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Bulk inserting data into bronze.crm_sales_details';
            BULK INSERT bronze.crm_sales_details
            FROM 'C:\Users\panos\Documents\Personal\SQL_Data_Warehouse_Project_Local\datasets\source_crm\sales_details.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time = GETDATE();
        PRINT '>> Elapsed time for bronze.crm_sales_details: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>---------------------------------';

        PRINT '--------------------------';
        PRINT 'Loading ERP Data...';
        PRINT '--------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Bulk inserting data into bronze.erp_cust_az12';
            BULK INSERT bronze.erp_cust_az12
            FROM 'C:\Users\panos\Documents\Personal\SQL_Data_Warehouse_Project_Local\datasets\source_erp\cust_az12.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time = GETDATE();
        PRINT '>> Elapsed time for bronze.erp_cust_az12: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>---------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.erp_cust_az13';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>> Bulk inserting data into bronze.erp_cust_az13';
            BULK INSERT bronze.erp_loc_a101
            FROM 'C:\Users\panos\Documents\Personal\SQL_Data_Warehouse_Project_Local\datasets\source_erp\loc_a101.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time = GETDATE();
        PRINT '>> Elapsed time for bronze.erp_loc_a101: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>---------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating bronze.erp_loc_a102';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>> Bulk inserting data into bronze.erp_loc_a102';
            BULK INSERT bronze.erp_px_cat_g1v2
            FROM 'C:\Users\panos\Documents\Personal\SQL_Data_Warehouse_Project_Local\datasets\source_erp\px_cat_g1v2.csv'
            WITH (
                FIRSTROW = 2,
                FIELDTERMINATOR = ',',
                TABLOCK
            );
        SET @end_time = GETDATE();
        PRINT '>> Elapsed time for bronze.erp_px_cat_g1v2: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>---------------------------------';

        SET @batch_end_time = GETDATE();
        PRINT '=========================';
        PRINT 'Bronze Layer loading completed successfully.';
        PRINT 'Total Elapsed Time for Bronze Layer: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '=========================';
    END TRY
        BEGIN CATCH
            PRINT '=========================';
            PRINT 'Error occurred during Bronze Layer loading.';
            PRINT 'Error Message: ' + ERROR_MESSAGE();
            PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
            PRINT'=========================';
            -- Optionally, you can log the error to a table or take other actions
        END CATCH
END