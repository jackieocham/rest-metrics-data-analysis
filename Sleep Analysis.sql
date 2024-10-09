-- When did I start tracking my sleep? --
SELECT *
FROM sleep_export
ORDER BY Id ASC LIMIT 1;

-- How many nights did I sleep over 7 hrs? --
SELECT *
FROM sleep_export;
# Outputs everyting in table 'sleep_export'
# Do this to see what we're working with

SELECT *
FROM sleep_export
WHERE Hours >= 7;
# Outputs everything in table if the value in 'Hours' is greater than or equal to 7
# Answer: rows returned in table where 'Hours' >= 7 is 1564
# How would I return the answer using code?

SELECT COUNT(Hours) AS Slept_AtLeast7_HRS 
FROM sleep_export
WHERE Hours >= 7;
# Outputs newly created column 'COUNT(Hours)' with answer 1564
# Named column using AS
# SELECT COUNT(*) also works because after the WHERE clause runs only the elements where the hours are >= 7 are output)

-- What is the average number of hours slept? --
SELECT AVG(Hours)
FROM sleep_export;
# Outputs 'AVG(Hours)' with answer 7.49

-- What was my adherence to using this sleep tracker? How many nights did I skip tracking my sleep? --
SELECT *
FROM sleep_export;
#

-- How many nights did I use Sonar? -- (Use SELECT DISTINT?)