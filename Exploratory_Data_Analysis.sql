-- Univariate Non-Graphical Analysis --

-- Begin by outputting the prepped data. Jot down questions that come up. --
SELECT *
FROM personal_data.prepped_sleep_data;

-- When did I start tracking my sleep? --
SELECT *
FROM personal_data.prepped_sleep_data
ORDER BY Id ASC LIMIT 1;
# Answer: 2018-10-30

-- How many nights did I sleep over 7 hrs? --
SELECT *
FROM prepped_sleep_data
WHERE Hours >= 7;
# Outputs everything in table if the record value in "Hours" is greater than or equal to 7
# Answer: rows returned in table is 1564

-- How would I return just the answer rather than all the records satisfying the condition? --
SELECT COUNT(Hours) AS Slept_AtLeast7_HRS 
FROM prepped_sleep_data
WHERE Hours >= 7;
# Outputs filtered result "COUNT(Hours)" with answer 1564
# Aliasing using AS replaces "COUNT(Hours)" with "Slept_AtLeast7_HRS"
# SELECT COUNT(*) also works because after the WHERE clause runs only the elements where the hours are >= 7 are output
# This is not as efficient - it is faster to count one field than to count everything!

-- What is the average number of hours slept? --
SELECT AVG(Hours)
FROM prepped_sleep_data;
# Outputs "AVG(Hours)" with answer 7.49

-- What was my adherence to using this sleep tracker? How many nights did I skip tracking my sleep? --
SELECT *
FROM prepped_sleep_data;
#

-- How many nights did I manually input my sleeping hours? --
-- How many nights did I use Sonar? -- (Use SELECT DISTINT?)

-- Multivariate Non-Graphical Analysis -- 
-- On days when I woke up before 7:00 AM, what time did I go to bed? --