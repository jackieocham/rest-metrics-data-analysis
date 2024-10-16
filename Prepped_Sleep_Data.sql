/* 1.) Import .csv file through the table data import wizard in desired database. Drop table if exist. 
The formatting of this .csv file is incorrect so all fields imported as text. */
SELECT *
FROM personal_data.original_sleep_export;
# Outputs everything from table 'original_sleep_export' in DB 'personal_data' to view in result grid

# 2.) Clean, scrub and prepare data for analysis.
ALTER TABLE original_sleep_export
DROP COLUMN Framerate,
DROP COLUMN LenAdjust,
DROP COLUMN Geo;
# Removes columns 'Framerate', 'LenAdjust', 'Geo' from table 'original_sleep_export'
# These fields are not needed for analysis

/* Get rid of error by turning off safe mode. 
Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect. */
SET SQL_SAFE_UPDATES = 0;

# The .csv file was incorrectly formatted with a row of field names and a row of null values after every row of values
DELETE FROM original_sleep_export
WHERE original_sleep_export.Tz = 'Tz';
# Removes every row where the element in column 'Tz' = 'Tz' getting rid of the extraneous field name records
DELETE FROM original_sleep_export
WHERE original_sleep_export.Tz = ''; # See extra notes below
# Removes all extraneous empty/null elements from the table by checking where the column 'Tz' contains an empty string ''

-- Change Column Names --
ALTER TABLE original_sleep_export
RENAME COLUMN `From` TO Bed_Time,
RENAME COLUMN `To` TO Wake_Time,
RENAME COLUMN Tz TO Timezone,
RENAME COLUMN Sched TO Next_Alarm;
# Field names changed for clarity. 
# Backticks needed around `From` and `To` because keywords

-- Reformat Field Information --
# This is required to change the data type of Bed_Time, Wake_Time and Next_Alarm from text to datetime 
UPDATE original_sleep_export
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

UPDATE original_sleep_export
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
    
UPDATE original_sleep_export
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
/* Updated table to set Bed_Time, Wake_Time, and Next_Alarm to the concatenation of the YYYY indexed substring to "-" 
to the MM indexed substring to "-" to the DD substring to " " to the HH:MM substring to ":SS".
If statement to concatenate "0" if time format is H:MM so it correctly and consistently reads HH:MM:SS.
Parameters for substring_index are (string, 'delimiter', count). Parameters for substring are (string, start position, length).
Parameters for if statement are (condition, value if true, value if false). */

# UPDATE 10Oct2024: Could have used COVERT function to add the zeros in front of single-digits instead of using if statement and concatenating zeros


SELECT Bed_Time, Wake_Time, Next_Alarm
FROM original_sleep_export;
# selected the 3 relevant fields from table to output and check work

SELECT COUNT(Bed_Time)
FROM original_sleep_export
WHERE LENGTH(Bed_Time) = 19;
# to thoroughly check work: there are 2244 records, so COUNT the number of records
# where the length of the string inside is 19 which is the correct length of datetime as a string

-- Change Column Data Types --
ALTER TABLE original_sleep_export MODIFY Id BIGINT;
ALTER TABLE original_sleep_export MODIFY Hours DOUBLE;
ALTER TABLE original_sleep_export MODIFY Rating DOUBLE;
ALTER TABLE original_sleep_export MODIFY Snore INT;
ALTER TABLE original_sleep_export MODIFY Noise DOUBLE;
ALTER TABLE original_sleep_export MODIFY Cycles INT;
ALTER TABLE original_sleep_export MODIFY DeepSleep DOUBLE;
ALTER TABLE original_sleep_export MODIFY Bed_Time DATETIME;
ALTER TABLE original_sleep_export MODIFY Wake_Time DATETIME;
ALTER TABLE original_sleep_export MODIFY Next_Alarm DATETIME;
# altered field data types for accuracy and to allow for quantitative analysis
# to verify data types, click the table name in the schemas tab in the navigator

/*3.) Name and export prepped data for graphical analysis. */