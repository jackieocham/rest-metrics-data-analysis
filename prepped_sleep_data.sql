/* 1. Imported .csv file through the table data import wizard to newly created database. 
      - Created new table named 'sleep_export'. Dropped table if exists. 
      - Selected the source columns according to Sleep By Android's app documentation.
      - Selected TEXT data type for all source columns due to strangely formatted data.
      - Took about 22 seconds to import 6,282 records. */      

/* 2. Output everything from table 'sleep_export' to view in result grid and start cleaning.
      - Read descriptions of each field in the app's documentation to determine if all were necessary. 
      - There is a row of headers every 2-3 lines. This duplicate data should be deleted.
      - There are many rows of empty data that need to be deleted. */
SELECT *
FROM sleep_export;

/* 3. Dropped unusable fields to decrease file size and make data more manageable. */
ALTER TABLE sleep_export
DROP COLUMN Framerate,
DROP COLUMN Geo;

/* 4. Deleted extraneous rows of headers and empty records to decrease file size and make data more manageable. 
      - Received message: "Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE 
      that uses a KEY column. To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.
      - Got rid of error by turning off safe mode. 
      - Filtered data using WHERE to find all records with the header string 'Id' inside.
      - Used data manipulation language (DML) to DELETE those rows from the table. 
      - Used WHERE and DELETE to find all records with empty strings and permanently remove them from the table. */
SET SQL_SAFE_UPDATES = 0;

DELETE FROM sleep_export
WHERE sleep_export.Id = 'Id';

DELETE FROM sleep_export
WHERE sleep_export.Tz = '';

/* 5. Changed column names to more clearly represent the type of data stored and to avoid using keywords in queries.
      - Used backticks around keywords `From` and `To`. */
ALTER TABLE sleep_export
RENAME COLUMN Tz TO Timezone,
RENAME COLUMN `From` TO Bed_Time,
RENAME COLUMN `To` TO Wake_Time,
RENAME COLUMN Sched TO Next_Alarm,
RENAME COLUMN Hours TO Hours_Recorded,
RENAME COLUMN Rating TO Sleep_Quality_Rating,
RENAME COLUMN `Comment` TO Notes,
RENAME COLUMN Cycles TO Sleep_Cycles,
RENAME COLUMN DeepSleep TO Deep_Sleep_Fraction,
RENAME COLUMN LenAdjust TO Minutes_Awake;  
    
/* 6. Reformatted 'Bed_Time', 'Wake_Time' and 'Next_Alarm' records to match correct format for the DATETIME data type in MySQL.
      METHOD 3: Using function STR_TO_DATE
      - METHOD 1 and METHOD 2 are noted in 'sleep_data_prep_summary.md' to preserve one-click execution of this file. */
UPDATE sleep_export
SET Bed_Time = STR_TO_DATE(Bed_Time,'%d. %m. %Y %H:%i');

UPDATE sleep_export
SET Wake_Time = STR_TO_DATE(Wake_Time,'%d. %m. %Y %H:%i');

UPDATE sleep_export
SET Next_Alarm = STR_TO_DATE(Next_Alarm,'%d. %m. %Y %H:%i');

/* 7. Changed table data types for multiple fields to be more accurate and allow for quantitative analysis.
      - Verified by clicking the table name in the schemas tab of the navigator and looking at object info. */
ALTER TABLE sleep_export MODIFY Bed_Time DATETIME;
ALTER TABLE sleep_export MODIFY Wake_Time DATETIME;
ALTER TABLE sleep_export MODIFY Next_Alarm DATETIME;
ALTER TABLE sleep_export MODIFY Hours_Recorded DEC(65, 2);
ALTER TABLE sleep_export MODIFY Sleep_Quality_Rating DEC(65, 2);
ALTER TABLE sleep_export MODIFY Snore INT;
ALTER TABLE sleep_export MODIFY Noise DEC(65, 15);
ALTER TABLE sleep_export MODIFY Sleep_Cycles INT;
ALTER TABLE sleep_export MODIFY Deep_Sleep_Fraction DEC(65, 10);
ALTER TABLE sleep_export MODIFY Minutes_Awake INT;

/* 8. Added column 'Entry_Date' with data type DATE to relate this table to prepped_health_data.csv.
      - This allows for data merge between the two tables. */
ALTER TABLE sleep_export
ADD Entry_Date DATE;
UPDATE sleep_export
SET Entry_Date = CONVERT(Wake_Time, DATE);

/* After performing some initial analysis, came across record(s) in 'Hours_Recorded' that should be deleted 
due to being too short. */
DELETE FROM sleep_export
WHERE Hours_Recorded < 0.1;

/* After performing some initial analysis, came across a new field that should be added to account for naps. */
ALTER TABLE sleep_export
ADD Nap BOOL;
UPDATE sleep_export
SET Nap = IF(
Hours_Recorded <= 4, 1, 0);

/* 9. Changed table name to 'prepped_sleep_data'. */
DROP TABLE IF EXISTS prepped_sleep_data;
ALTER TABLE sleep_export
RENAME prepped_sleep_data;

/* 10. Output everything from table 'prepped_sleep_data' to result grid for viewing pleasure of freshly cleaned and prepped data. */
SELECT *
FROM prepped_sleep_data;

/* 11. Exported table as CSV file using table data export wizard to use for visualizations. */
