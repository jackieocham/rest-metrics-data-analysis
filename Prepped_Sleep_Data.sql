-- 1.) Import .csv file "original_sleep_export" through the table data import wizard. --
-- 2.) When asked for source columns, exclude all fields after "Geo."  --

SELECT *
FROM personal_data.original_sleep_export;
# Outputs everything from table 'original_sleep_export' in DB 'personal_data'

ALTER TABLE original_sleep_export
DROP COLUMN Framerate,
DROP COLUMN LenAdjust,
DROP COLUMN Geo;
# Removes multiple columns 'Framerate', 'LenAdjust', 'Geo' from table 'original_sleep_export'
# PERMANENT CHANGE: SAVE A COPY OF ORIGINAL TABLE FIRST!!

DELETE FROM original_sleep_export
WHERE original_sleep_export.Tz = 'Tz';
# Removes every row where the element in column 'Tz' = 'Tz'

SET SQL_SAFE_UPDATES = 0;
# Gets rid of error by turning off safe mode: 
# Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column. 
# To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

DELETE FROM original_sleep_export
WHERE original_sleep_export.Tz = ''; # Extra Notes
# Removes all empty/null elements from the table by checking where the column 'Tz' contains an empty string ''

SELECT *
FROM personal_data.original_sleep_export;
# Output everything from updated table 

-- Extra Notes about Data Types and Stuff --
# The query 'WHERE original_sleep_export.Tz IS NULL;' does not work in this case
# because the datatype of all the fields had to be imported as text 
# becasue the field names were inserted as records between each row of values in the data exported directly from my sleep tracking app