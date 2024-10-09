SELECT *
FROM personal_data.sleep_export;
# Outputs everything from table 'sleep_export' in DB 'personal_data'

ALTER TABLE sleep_export
DROP COLUMN Framerate;
SELECT *
FROM personal_data.sleep_export;
# Removes the column 'Framerate' from the table 'sleep_export'
# Output everything from updated table 

ALTER TABLE sleep_export
DROP COLUMN LenAdjust,
DROP COLUMN Geo;
SELECT *
FROM personal_data.sleep_export;
# Removes multiple columns 'LenAdjust','Geo' from table 'sleep_export'
# Output everything from updated table 

DELETE FROM sleep_export
WHERE sleep_export.Tz = 'Tz';
SELECT *
FROM personal_data.sleep_export;
# Removes every row where the element in column 'Tz' = 'Tz'
# Output everything from updated table 

SET SQL_SAFE_UPDATES = 0;
# Gets rid of error by turning off safe mode: 
# Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
# To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

DELETE FROM sleep_export
WHERE sleep_export.Tz = ''; # Extra Notes
SELECT *
FROM personal_data.sleep_export;
# Removes all empty/null elements from the table by checking where the column 'Tz' contains an empty string ''
# Output everything from updated table 

-- Extra Notes about Data Types and Stuff --
# The query 'WHERE sleep_export.Tz IS NULL;' would work, but not in this case
# because the datatype of all the columns had to be imported as text 
# becasue the column headers were inserted between each row of values in the body of the data exported directly 
# from Sleep By Android