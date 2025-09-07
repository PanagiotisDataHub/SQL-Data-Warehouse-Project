/*
    00_init_database.sql
    ---------------------

    This file serves as a placeholder for initializing the database
    in the Analytics context. 

    Note:
    - The main database and schemas (bronze, silver, gold) are already 
      created using the root-level /scripts/init_database.sql file.
    - You can skip this step if the Data Warehouse is already built.

    Purpose:
    - Keep script numbering consistent (00 → 01 → 02 …).
    - Provide a starting point if someone wants to run only the analytics 
      scripts in a separate environment.
*/

-- Example: switch to the DataWarehouse DB (adjust if needed)
USE DataWarehouse;
GO