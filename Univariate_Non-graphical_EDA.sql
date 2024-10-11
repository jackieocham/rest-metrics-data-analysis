-- Begin by outputting the entire data set for univariate non-graphical analysis. --
SELECT *
FROM personal_data.sleep_export;
# Outputs all fields and records in the table

-- When did I start tracking my sleep? --
SELECT *
FROM personal_data.sleep_export
ORDER BY Id ASC LIMIT 1;
# Answer: 2018-10-30

-- How many nights did I sleep over 7 hrs? --
SELECT *
FROM sleep_export
WHERE Hours >= 7;
# Outputs everything in table if the record value in "Hours" is greater than or equal to 7
# Answer: rows returned in table is 1564

-- How would I return just the answer rather than all the records satisfying the condition? --
SELECT COUNT(Hours) AS Slept_AtLeast7_HRS 
FROM sleep_export
WHERE Hours >= 7;
# Outputs filtered result "COUNT(Hours)" with answer 1564
# Aliasing using AS replaces "COUNT(Hours)" with Slept_AtLeast7_HRS
# SELECT COUNT(*) also works because after the WHERE clause runs only the elements where the hours are >= 7 are output

-- What is the average number of hours slept? --
SELECT AVG(Hours)
FROM sleep_export;
# Outputs "AVG(Hours)" with answer 7.49

-- What was my adherence to using this sleep tracker? How many nights did I skip tracking my sleep? --
SELECT *
FROM sleep_export;
#

-- How many nights did I manually input my sleeping hours? --

-- How many nights did I use Sonar? -- (Use SELECT DISTINT?)