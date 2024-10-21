/* 1. Imported .csv file through the table data import wizard to newly created database. 
      - Created new table named 'sleep_export'. Dropped table if exists. 
      - Selected the source columns (out of *thousands*) according to Sleep By Android's documentation.
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
      METHOD 1:
      - Started with incorrect DATETIME format: 'DD. MM. YYYY [h]h:mm'. 
        - Single digit hours did not have a zero in front.
        - Missing seconds ':ss' from the time.
      - Concatenated the pulled pieces of the the date and time to each other in the correct order.
        - Pulled 'YYYY' string from Q1 using SUBSTRING_INDEX(Q1, ' ', 1). 
          - Returns everything from the left up to 1st delimiter.
          - Q1 = SUBSTRING_INDEX(col_name, ' ', -2) = 'YYYY [h]h:mm'. 
            - Returns everything from the right up to 2nd delimiter.
        - Concatenated 'YYYY' to '-' to the nested indexed substring query that returned 'MM'.
        - Pulled 'MM' string from Q2 using SUBSTRING_INDEX(Q2, ' ', -1). 
          - Returns everything from the right up to 1st delimiter.
          - Q2 = SUBSTRING_INDEX(col_name, '.', 2) = 'DD. MM'. 
            - Returns everything from the left up to 2nd delimiter.
        - Concatenation continues to '-' to the substring query that returned 'DD'.
        - Pulled 'DD' string from 'DD. MM. YYYY [h]h:mm' using SUBSTRING(col_name, 1, 2).
          - Returns a string of 2 length, starting at the 1st position in 'col_name'.
        - Concatenation continues to ' ' to the resolution of the conditional function IF.
          - If the length of the indexed substring Q3 is less than the expected length("hh:mm") = 5
            - Condition if true: concat to '0' to Q3.
            - Condition if false: output Q3.
            - Q3 = SUBSTRING_INDEX(col_name, ' ', -1) = '[h]h:mm'.
              - Returns everything from the right up to the first delimiter.
        - Concatenation finalized with ":00" to account for the missing ':ss' in the incorrect format.
      - Ended with correct DATETIME format: 'YYYY-MM-DD hh:mm:ss'. :D
      - Verified all records were in the proper format by counting where length = 19 because LENGTH("YYYY-MM-DD hh:mm:ss") = 19.  
        - There are 2286 rows of data and count is 2286 where the string = 19 so manual reformat worked. */
UPDATE sleep_export
SET Bed_Time = 
	CONCAT(SUBSTRING_INDEX(
		SUBSTRING_INDEX(Bed_Time, ' ', -2), ' ', 1
    ), "-", SUBSTRING_INDEX(
		SUBSTRING_INDEX(Bed_Time, '.', 2), ' ', -1
    ), "-", SUBSTRING(Bed_Time, 1, 2),
    " ", 
    IF 
    (LENGTH(SUBSTRING_INDEX(Bed_Time, ' ', -1)) < 5, 
    CONCAT("0", SUBSTRING_INDEX(Bed_Time, ' ', -1)), 
	SUBSTRING_INDEX(Bed_Time, ' ', -1)), 
    ":00"); 

UPDATE sleep_export
SET Wake_Time = 
	CONCAT(SUBSTRING_INDEX(
		SUBSTRING_INDEX(Wake_Time, ' ', -2), ' ', 1
    ), "-", SUBSTRING_INDEX(
		SUBSTRING_INDEX(Wake_Time, '.', 2), ' ', -1
    ), "-", SUBSTRING(Wake_Time, 1, 2),
    " ", 
    IF 
    (LENGTH(SUBSTRING_INDEX(Wake_Time, ' ', -1)) < 5, 
    CONCAT("0", SUBSTRING_INDEX(Wake_Time, ' ', -1)), 
	SUBSTRING_INDEX(Wake_Time, ' ', -1)), 
    ":00"); 
    
UPDATE sleep_export
SET Next_Alarm = 
	CONCAT(SUBSTRING_INDEX(
		SUBSTRING_INDEX(Next_Alarm, ' ', -2), ' ', 1
    ), "-", SUBSTRING_INDEX(
		SUBSTRING_INDEX(Next_Alarm, '.', 2), ' ', -1
    ), "-", SUBSTRING(Next_Alarm, 1, 2),
    " ", 
    IF 
    (LENGTH(SUBSTRING_INDEX(Next_Alarm, ' ', -1)) < 5, 
    CONCAT("0", SUBSTRING_INDEX(Next_Alarm, ' ', -1)), 
	SUBSTRING_INDEX(Next_Alarm, ' ', -1)), 
    ":00"); 

SELECT COUNT(Bed_Time), COUNT(Wake_Time), COUNT(Next_Alarm)
FROM sleep_export
WHERE LENGTH(Bed_Time) = LENGTH("YYYY-MM-DD hh:mm:ss") 
AND LENGTH(Wake_Time) = LENGTH("YYYY-MM-DD hh:mm:ss") 
AND LENGTH(Next_Alarm) = LENGTH("YYYY-MM-DD hh:mm:ss");

/* 6. Reformatted 'Bed_Time', 'Wake_Time' and 'Next_Alarm' records to match correct format for the DATETIME data type in MySQL.
      METHOD 2:
      - Simplified reformatting process by using the CONVERT function instead of using IF function and concatenating zeros.
        - Changed the data to the DATETIME format which auto-added the zeros.
        - Concatenation of "-"s and re-ordering of pulled pieces (as described in Method 1) still required. */
UPDATE sleep_export
SET Bed_Time = 
	CONVERT(CONCAT(SUBSTRING_INDEX(
		SUBSTRING_INDEX(Bed_Time, ' ', -2), ' ', 1
    ), "-", SUBSTRING_INDEX(
		SUBSTRING_INDEX(Bed_Time, '.', 2), ' ', -1
    ), "-", SUBSTRING(Bed_Time, 1, 2),
    " ", SUBSTRING_INDEX(Bed_Time, ' ', -1)), DATETIME); 

UPDATE sleep_export
SET Wake_Time = 
	CONVERT(CONCAT(SUBSTRING_INDEX(
		SUBSTRING_INDEX(Wake_Time, ' ', -2), ' ', 1
    ), "-", SUBSTRING_INDEX(
		SUBSTRING_INDEX(Wake_Time, '.', 2), ' ', -1
    ), "-", SUBSTRING(Wake_Time, 1, 2),
    " ", SUBSTRING_INDEX(Wake_Time, ' ', -1)), DATETIME); 

UPDATE sleep_export
SET Next_Alarm = 
	CONVERT(CONCAT(SUBSTRING_INDEX(
		SUBSTRING_INDEX(Next_Alarm, ' ', -2), ' ', 1
    ), "-", SUBSTRING_INDEX(
		SUBSTRING_INDEX(Next_Alarm, '.', 2), ' ', -1
    ), "-", SUBSTRING(Next_Alarm, 1, 2),
    " ", SUBSTRING_INDEX(Next_Alarm, ' ', -1)), DATETIME);  
    
/* 6. Reformatted 'Bed_Time', 'Wake_Time' and 'Next_Alarm' records to match correct format for the DATETIME data type in MySQL
and updated the table to permanently change the data types to DATETIME for all 3 fields.
      METHOD 3: *most efficient*
      - Simplified the reformatting process by using the function STR_TO_DATE.
      - This is the way. */
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
ALTER TABLE sleep_export MODIFY Hours_Recorded DEC(65, 30);
ALTER TABLE sleep_export MODIFY Sleep_Quality_Rating DEC(65, 30);
ALTER TABLE sleep_export MODIFY Snore INT;
ALTER TABLE sleep_export MODIFY Noise DEC(65, 30);
ALTER TABLE sleep_export MODIFY Sleep_Cycles INT;
ALTER TABLE sleep_export MODIFY Deep_Sleep_Fraction DEC(65, 30);
ALTER TABLE sleep_export MODIFY Minutes_Awake INT;

/* 8. Output everything from table 'sleep_export' to result grid for viewing pleasure of freshly cleaned and prepped data. */
SELECT *
FROM sleep_export;

/*9.) Exported prepped data as .csv file using table date export wizard to project folder on local machine for further analysis. */
