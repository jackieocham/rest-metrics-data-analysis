/* Narcoleptic Sleep Data Analysis by Jacqueline Chambers
Ongoing intuitive analyses since diagnosis in October 2016; 
Professional analyses started September 2024 for data portfolio. ^_^ 
Description: Sleep data was exported from the sleep tracking app, "Sleep By Android," and imported to a local MySQL DB
for cleaning and prep (see prepped_sleep_data.sql). Health data was exported from the app, "Ovuview," and imported to
Excel for cleaning then to the same local MySQL DB for prep (see prepped_health_data.sql). Initial analysis begins below. */

-- Output prepped data. Answer general questions. --
SELECT *
FROM prepped_sleep_data;

SELECT *
FROM prepped_health_data;

-- What date did tracking begin? --
SELECT Bed_Time
FROM prepped_sleep_data
ORDER BY Bed_Time ASC LIMIT 1;
# Answer: sleep tracking began 2018-10-30

SELECT Entry_Date
FROM prepped_health_data
ORDER BY Entry_Date ASC LIMIT 1;
# Answer: health tracking began 2014-04-02

-- What date was tracking exported? --
SELECT Wake_Time
FROM prepped_sleep_data
ORDER BY Bed_Time DESC LIMIT 1;
# Answer: sleep tracking was exported 2024-09-14

SELECT Entry_Date
FROM prepped_health_data
ORDER BY Entry_Date DESC LIMIT 1;
# Answer: health tracking was exported 2022-02-22


-- How many tracking entries in total? --
SELECT COUNT(Id)
FROM prepped_sleep_data;
# Answer: 2244

SELECT COUNT(Entry_Date)
FROM prepped_health_data;
# Answer: 2063

-- What was the adherence to using this these trackers? How many days missed tracking? --
# The date range Oct 30, 2018 - Sept 14, 2024 includes 2,146 days
SELECT 2146 - COUNT(DISTINCT DATE(Wake_Time))
FROM prepped_sleep_data;
# Answer: 24 missing days
SELECT COUNT(DISTINCT DATE(Wake_Time))/2146
FROM prepped_sleep_data;
# Answer: 98.89% adherence to using sleep tracker

# The date range Apr 02, 2014 - Feb 22, 2022 includes 2,883 days
SELECT 2883 - COUNT(DISTINCT(Entry_Date))
FROM prepped_health_data;
# Answer: 820 missing days
SELECT COUNT(DISTINCT(Entry_Date))/2883
FROM prepped_health_data;
# Answer: 71.56% adherence to using health tracker

-- Which dates are missing? --
SELECT DISTINCT DATE(w1.Wake_Time) + INTERVAL 1 DAY AS missing_date FROM prepped_sleep_data w1 
LEFT OUTER JOIN (SELECT DISTINCT Wake_Time FROM prepped_sleep_data) w2 
ON DATE(w1.Wake_Time) = DATE(w2.Wake_Time) - INTERVAL 1 DAY 
WHERE w1.Wake_Time BETWEEN (SELECT MIN(w1.Wake_Time)) AND (SELECT MAX(w1.Wake_Time)) AND w2.Wake_Time IS NULL;
# I believe this is incorrect. Will research and return.

SELECT DISTINCT DATE(w1.Entry_Date) + INTERVAL 1 DAY AS missing_date FROM prepped_health_data w1 
LEFT OUTER JOIN (SELECT DISTINCT Entry_Date FROM prepped_health_data) w2 
ON DATE(w1.Entry_Date) = DATE(w2.Entry_Date) - INTERVAL 1 DAY 
WHERE w1.Entry_Date BETWEEN (SELECT MIN(w1.Entry_Date)) AND (SELECT MAX(w1.Entry_Date)) AND w2.Entry_Date IS NULL;

-- UNIVARIATE FOCUS: Hours

-- Given a good night's rest requires at least 7.5 hrs of sleep, how many entries could be good night's rest? --
SELECT Hours
FROM prepped_sleep_data
WHERE Hours > 7.5;
# Answer: rows returned in table is 1246
# The answer does not include any entries that are exactly 7.5 hrs
# The answer is not immediately clear using this query. The next query is better. 

-- How many entries with at least 7.5 hrs of sleep? --
SELECT COUNT(Hours) AS enoughSleep 
FROM prepped_sleep_data
WHERE Hours >= 7.5;
# Answer: 1258 
# Aliasing using AS replaces "COUNT(Hours)" with "enoughSleep"
# SELECT COUNT(*) also works but is not as efficient - it is faster to count one field than to count everything.

-- What percent of entries could be good night's rest? --
# There are 2244 entries in total answered above
SELECT ((SELECT COUNT(Id) FROM prepped_sleep_data) - COUNT(Hours))/(SELECT COUNT(Id) FROM prepped_sleep_data)
AS amountEnoughSleep
FROM prepped_sleep_data
WHERE Hours >= 7.5;
# Answer: 43.94% of entries could be considered a good night's rest

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
SELECT Bed_Time, Wake_Time, Hours, `Comment` 
FROM prepped_sleep_data
WHERE Hours <= 6
AND HOUR(Bed_Time) BETWEEN 06 AND 21
ORDER BY Hours DESC;
# Answer: It looks like there a quite a few nights stayed up until after 6:00 AM and then slept for less than 6 hours
# This is more of a late bed time with not enough sleep than a nap. See updated queries below.

SELECT COUNT(Bed_Time)
FROM prepped_sleep_data
WHERE Hours <= 5
AND HOUR(Bed_Time) BETWEEN 07 AND 21;
# Answer: 47

SELECT Bed_Time, Wake_Time, Hours, `Comment` 
FROM prepped_sleep_data
WHERE Hours <= 5
AND HOUR(Bed_Time) BETWEEN 07 AND 21
ORDER BY Hours DESC;
# These entries look more like naps. Sometimes I had to nap after teaching a 6:00am fitness class.
/* The record with 4.9 hours on 2024-06-12 looks weird - I checked it against my calendar and it looks like an anomaly.
II slept June 11, 2024, 11:56pm – June 12, 2024, 6:58am and went back to sleep at 7:09am for some reason. */




-- How many entries were manually added? --
SELECT COUNT(`Comment`)
FROM prepped_sleep_data
WHERE `Comment` LIKE "Manually%";
# Answer: 110
# Manually added entries are where I forgot to start sleeping tracking before falling asleep. 
# The app runs in the background and estimates my sleep times when I wake up in the morning, giving me an option to manually add them.



-- How many sleep tracking entries start and end on the same day? --
SELECT COUNT(Id)
FROM prepped_sleep_data
WHERE DATE(Bed_Time) = DATE(Wake_Time) AND Hours > 5;
# Answer: 1560
# These are entries when sleep tracking started after midnight or a nap was taken

-- How many nights did I use Sonar vs watch vs manual? Make a pie chart. --
-- How many nights did I get above 30% deep sleep? --