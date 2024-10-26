/* 1. Imported .csv file through the table data import wizard to newly created database. 
      - Created new table named 'prepped_health_data'. Dropped table if exists. 
      - Selected all source columns.
      - Keep default data types for all source columns due to pre-prep in Excel.
      - Took about 11 seconds to import 3018 records. */
      
/* 2. Output everything from table 'prepped_health_data' to view in result grid and start cleaning.
      - Field name 'Entry_Date' has weird characters in it.
      - 'Entry_Date' is not correctly formatted for DATE data type. */
SELECT *
FROM prepped_health_data;

/* 3. Changed 'ï»¿Entry_Date' field name to 'Entry_Date'. */
ALTER TABLE prepped_health_data
RENAME COLUMN `ï»¿Entry_Date` TO Entry_Date;

/* 4. Reformated 'Entry_Date' from "m/d/Y" to "YYYY-MM-DD". */
UPDATE prepped_health_data
SET Entry_Date = STR_TO_DATE(Entry_Date,'%m/%d/%Y');

/* 5. Changed data type of 'Entry_Date' from TEXT to DATE.
      - Turned off safe mode to avoid error.
            - "Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
            To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect. */
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE prepped_health_data MODIFY Entry_Date DATE;

/* 6. Output everything from table 'prepped_health_data' to result grid for viewing pleasure. */
SELECT *
FROM prepped_health_data;
