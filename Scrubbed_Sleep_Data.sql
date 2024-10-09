SET SQL_SAFE_UPDATES = 0;
# Gets rid of error by turning off safe mode: 
# Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
# To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- Change Column Names --
ALTER TABLE sleep_export
RENAME COLUMN `From` TO Bedtime;
SELECT *
FROM personal_data.sleep_export;

ALTER TABLE sleep_export
RENAME COLUMN `To` TO Wake_Time,
RENAME COLUMN Tz TO Timezone,
RENAME COLUMN Bedtime TO Bed_Time,
RENAME COLUMN Sched TO Next_Alarm;
SELECT *
FROM personal_data.sleep_export;
# Renamed columns for clarity

-- Reformat Field Information --
-- This is required to change the data type of Bed_Time from text to datetime
ALTER TABLE sleep_export
ADD Reform_Bed_Time VARCHAR(25);
UPDATE sleep_export
SET Reform_Bed_Time = 
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
SELECT Bed_Time, Reform_Bed_Time
FROM sleep_export;
# altered table to add a new field called Reform_Bed_Time with data type "variable_character(length)"
# updated table to concatenate the YYYY indexed substring to "-" to the MM indexed substring to "-" to the DD substring
# to " " to the HH:MM substring to ":SS" from "Bed_Time" into "Reform_Bed_Time"
# if statement to concatenate "0" if time format = H:MM so format correctly and consistently reads HH:MM:SS
# parameters for substring_index are (string, 'delimiter', count)
# parameters for substring are (string, start position, length)
# parameters for if statement are (condition, value if true, value if false)
# selected the 2 relevant fields from table to output and check work

SELECT COUNT(Reform_Bed_Time)
FROM sleep_export
WHERE LENGTH(Reform_Bed_Time) = 19;
# to check my work, I know there are 2244 records, so I counted the number of records
# where the length of the string inside is 19 which is the correct length of datetime format

-- Change Column Datatypes --
ALTER TABLE sleep_export MODIFY Id BIGINT;
SELECT *
FROM personal_data.sleep_export;

ALTER TABLE sleep_export MODIFY Hours DOUBLE;
ALTER TABLE sleep_export MODIFY Rating DOUBLE;
ALTER TABLE sleep_export MODIFY Snore INT;
ALTER TABLE sleep_export MODIFY Noise DOUBLE;
ALTER TABLE sleep_export MODIFY Cycles INT;
ALTER TABLE sleep_export MODIFY DeepSleep DOUBLE;
ALTER TABLE sleep_export MODIFY Reform_Bed_Time DATETIME;
SELECT *
FROM personal_data.sleep_export;
# altered field data types to be more accurate and allow for accurate mathematical analysis with numbers