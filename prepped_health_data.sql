/* Goal: Import additional health data into database with sleep data.
Prep data - change the name of the "Date" field, reformat the date syntax, change the data type to datetime. */

SELECT *
FROM prepped_health_data;

-- Change "ï»¿Date" Field Name --
ALTER TABLE prepped_health_data
RENAME COLUMN `ï»¿Date` TO Entry_Date;

-- Change DataType of Entry_Date from TEXT to DATE --
SET SQL_SAFE_UPDATES = 0;
UPDATE prepped_health_data
SET Entry_Date = CONVERT(
CONCAT_WS("-", SUBSTRING_INDEX(Entry_Date, '/', -1), 
SUBSTRING_INDEX(Entry_Date, '/', 1),
SUBSTRING_INDEX(SUBSTRING_INDEX(Entry_Date, '/', -2), '/', 1)), DATE);
ALTER TABLE prepped_health_data MODIFY Entry_Date DATE;
# Used convert to add the zeros in front of single-digit days and months