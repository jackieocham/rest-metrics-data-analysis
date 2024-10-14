-- Univariate Non-Graphical Analysis --
-- Begin by outputting the prepped data. Jot down questions that come up. --
SELECT *
FROM personal_data.prepped_sleep_data;

-- When did sleep tracking begin? --
SELECT Bed_Time
FROM prepped_sleep_data
ORDER BY Bed_Time ASC LIMIT 1;
# Answer: 2018-10-30 22:55:00

-- How many sleep tracking entries in total? --
SELECT COUNT(Id)
FROM prepped_sleep_data;
# Answer: 2244

-- How many entries with over 8 hrs of sleep? --
SELECT Hours
FROM prepped_sleep_data
WHERE Hours > 8;
# Answer: rows returned in table is 887
# The answer is not immediately clear using this query. The next query is better. 

-- How many entries with at least 8 hrs of sleep? --
SELECT COUNT(Hours) AS countAtLeast8HrSlept 
FROM prepped_sleep_data
WHERE Hours >= 8;
# Answer: 892 
# Aliasing using AS replaces "COUNT(Hours)" with "countAtLeast8HrSlept"
# SELECT COUNT(*) also works but is not as efficient - it is faster to count one field than to count everything.

-- How many entries with 6 or less hrs of sleep? --
SELECT COUNT(Hours)
FROM prepped_sleep_data
WHERE Hours <= 6;
# Answer: 318

-- What is the average number of hours slept? --
SELECT AVG(Hours) AS avgHrsSlept
FROM prepped_sleep_data;
# Answer: 7.49 average hours slept
# Some of the hours slept could be from naps. Clarify. 

-- How many entries could be naps during the day? --
SELECT COUNT(Bed_Time)
FROM prepped_sleep_data
WHERE Hours <= 6
AND HOUR(Bed_Time) BETWEEN 06 AND 21;
# Answer: 60

-- What do these naps look like? --
SELECT Bed_Time, Hours, `Comment` 
FROM prepped_sleep_data
WHERE Hours <= 6
AND HOUR(Bed_Time) BETWEEN 06 AND 21;
# Answer: It looks like there a quite a few nights stayed up until after 6:00 AM and then slept for less than 6 hours
# This is more of a late bed time with not enough sleep than a nap. See updated queries below.

SELECT COUNT(Bed_Time)
FROM prepped_sleep_data
WHERE Hours <= 5
AND HOUR(Bed_Time) BETWEEN 07 AND 21;
# Answer: 47

SELECT Bed_Time, Hours, `Comment` 
FROM prepped_sleep_data
WHERE Hours <= 5
AND HOUR(Bed_Time) BETWEEN 07 AND 21;
# These entries look more like naps. Sometimes I had to nap after teaching a 6:00 AM fitness class.

-- How many entries were manually added? --
SELECT COUNT(`Comment`)
FROM prepped_sleep_data
WHERE `Comment` LIKE "Manually%";
# Answer: 110
# Manually added entries are entries where I forgot to start sleeping tracking before falling asleep. 
# The app runs in the background and estimates my sleep times when I wake up in the morning, giving me an option to manually add them.

/* What was the adherence to using this sleep tracker? How many days missed tracking sleep?
	According to google, the date range Oct 30, 2018 - Sept 14, 2024 includes 2,146 days */
SELECT 2146 - COUNT(DISTINCT DATE(Wake_Time))
FROM prepped_sleep_data;
# Answer: 24 missing days
SELECT COUNT(DISTINCT DATE(Wake_Time))/2146
FROM prepped_sleep_data;
# Answer: 98.89% adherence to tracking sleep

-- Which dates are missing? --
SELECT DISTINCT DATE(w1.Wake_Time) + INTERVAL 1 DAY AS missing_date FROM prepped_sleep_data w1 
LEFT OUTER JOIN (SELECT DISTINCT Wake_Time FROM prepped_sleep_data) w2 
ON DATE(w1.Wake_Time) = DATE(w2.Wake_Time) - INTERVAL 1 DAY 
WHERE w1.Wake_Time BETWEEN (SELECT MIN(w1.Wake_Time)) AND (SELECT MAX(w1.Wake_Time)) AND w2.Wake_Time IS NULL;
# This is not correct. Not sure how to trouble shoot.

-- How many sleep tracking entries start and end on the same day? --
SELECT COUNT(Id)
FROM prepped_sleep_data
WHERE DATE(Bed_Time) = DATE(Wake_Time) AND Hours > 4;
# Answer: 1621
# These are entries when sleep tracking started after midnight or a nap was taken

-- How many nights did I use Sonar vs watch vs manual? Make a pie chart. --
-- How many nights did I get above 30% deep sleep? --