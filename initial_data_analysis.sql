/*  Narcoleptic Sleep Data Analysis by Jacqueline Chambers
    - Data collection started April 2014 for general health and sleep tracking.
    - Switched to a better app in October 2018 for sleep tracking.
    - Data analysis started September 2024 for project portfolio.

    Description: Sleep data was exported from the sleep tracking app and imported to a local MySQL DB
    for cleaning and prep (see prepped_sleep_data.sql). Health data was exported from the app and imported to
    Excel for cleaning and prep (see health_data_prep_summary.md), then to the same DB for final prep (see prepped_health_data.sql). 
    Initial analysis begins below. */

-- THE DATA --

SELECT *
FROM prepped_sleep_data;

SELECT *
FROM prepped_health_data;

-- GENERAL QUESTIONS --

/* G1. What date did tracking begin?
- sleep: 2018-10-30
- health: 2014-04-02 */
SELECT DATE(Bed_Time) AS BeginSleepTracking
FROM prepped_sleep_data
ORDER BY Bed_Time ASC LIMIT 1;

SELECT Entry_Date AS BeginHealthTracking
FROM prepped_health_data
ORDER BY Entry_Date ASC LIMIT 1; 

/* G2. What date was tracking data last exported?
- sleep: 2024-10-20 
- health: 2024-10-20 */
SELECT DATE(Wake_Time) AS SleepExportDate
FROM prepped_sleep_data
ORDER BY Bed_Time DESC LIMIT 1;

SELECT Entry_Date AS HealthExportDate
FROM prepped_health_data
ORDER BY Entry_Date DESC LIMIT 1;

/* G3. How many total entries?
- sleep: 2278
- health: 3018 */
SELECT COUNT(Id) AS SleepRecords
FROM prepped_sleep_data;

SELECT COUNT(Entry_Date) AS HealthRecords
FROM prepped_health_data;

/* G4. What was the adherence to using these trackers? How many days missed tracking?
- sleep: 25 missing days, 98.9% adherence to tracking for the duration
    * Date range Oct 30, 2018 - Oct 20, 2024 includes 2,182 days.
- health: 836 missing days, 78.31% adherence to tracking for the duration
    * Date range Apr 02, 2014 - Oct 20, 2024 includes 3,854 days. */
SELECT 2182 - COUNT(DISTINCT DATE(Wake_Time)) AS MissingSleepEntries
FROM prepped_sleep_data;
SELECT COUNT(DISTINCT DATE(Wake_Time))/2182 AS SleepTrackingAdherence
FROM prepped_sleep_data;

SELECT 3854 - COUNT(DISTINCT(Entry_Date)) AS MissingHealthEntries
FROM prepped_health_data;
SELECT COUNT(DISTINCT(Entry_Date))/3854 AS HealthTrackingAdherence
FROM prepped_health_data;

/* G5. Which dates are missing? (Still working on this one)
- sleep:
- health:
SELECT DISTINCT DATE(w1.Wake_Time) + INTERVAL 1 DAY AS missing_date FROM prepped_sleep_data w1 
LEFT OUTER JOIN (SELECT DISTINCT Wake_Time FROM prepped_sleep_data) w2 
ON DATE(w1.Wake_Time) = DATE(w2.Wake_Time) - INTERVAL 1 DAY 
WHERE w1.Wake_Time BETWEEN (SELECT MIN(w1.Wake_Time)) AND (SELECT MAX(w1.Wake_Time)) AND w2.Wake_Time IS NULL;

SELECT DISTINCT DATE(w1.Entry_Date) + INTERVAL 1 DAY AS missing_date FROM prepped_health_data w1 
LEFT OUTER JOIN (SELECT DISTINCT Entry_Date FROM prepped_health_data) w2 
ON DATE(w1.Entry_Date) = DATE(w2.Entry_Date) - INTERVAL 1 DAY 
WHERE w1.Entry_Date BETWEEN (SELECT MIN(w1.Entry_Date)) AND (SELECT MAX(w1.Entry_Date)) AND w2.Entry_Date IS NULL; */

/*G6. How many entries were manually added?
- 111 manually added sleep records. The app runs in the background and estimates sleep times after waking in the morning, 
    giving an option to manually add sleep duration. */
SELECT COUNT(Notes) AS ManualRecords
FROM prepped_sleep_data
WHERE Notes LIKE "%anual%";

/* G7. How many sleep tracking entries start and end on the same day?
- 1637 entries. These are entries when sleep tracking started after midnight or a nap was taken. */
SELECT COUNT(Id) AS BedtimeAfterMidnight
FROM prepped_sleep_data
WHERE DATE(Bed_Time) = DATE(Wake_Time) AND Hours_Recorded > 4;


-- DATA ON *HOURS* OF SLEEP -- 

/* H1. How many entries show 7.5 hrs of sleep?
- 1270 entries, which is about 40 months or about 3.5 years
    * Answer is not immediately clear using this query, had to look at row(s) returned in the 'Action Output' window. */
SELECT COUNT(Hours_Recorded) AS AlmostEnoughSleepCount
FROM prepped_sleep_data
WHERE Hours_Recorded > 7.5;

/* H2. How many entries show at least 7.5 hrs of sleep?
- 1282 entries, which is about 41 months or about 3.5 years
    * SELECT COUNT(*) also works but is not as efficient - it is faster to count one field than to count everything. */
SELECT COUNT(Hours_Recorded) AS EnoughSleepCount
FROM prepped_sleep_data
WHERE Hours_Recorded >= 7.5;

/* H3. What percentage of entries show at least 7.5 hrs of sleep?
- 43.72% of entries show 7.5 hrs of sleep
	* This data does not include my sleep tracking from my health app. Revisit to update later. */
SELECT(
(SELECT COUNT(Id) FROM prepped_sleep_data) - COUNT(Hours_Recorded)
)/(SELECT COUNT(Id) FROM prepped_sleep_data)
AS PercentEnoughSleep
FROM prepped_sleep_data
WHERE Hours_Recorded >= 7.5;

/* H4. How many entries with 6 or less hrs of sleep?
- 328 entries with 6 or less hrs of sleep */
SELECT COUNT(Hours_Recorded) AS NotEnoughSleepCount
FROM prepped_sleep_data
WHERE Hours_Recorded <= 6;

/* H5. What is the average number of hours slept?
- 7.50 average hours 
    * Some of the hours slept could be from naps. Investigate further. */
SELECT AVG(Hours_Recorded) AS AvgHrsSlept
FROM prepped_sleep_data;

/* H6. What is the minimum number of hours slept in one entry? When did it take place?
- 0.1 hours (or 6 minutes) on Jan 02, 2019. */
SELECT MIN(Hours_Recorded) AS HoursAscending, Bed_Time, Wake_Time, Notes
FROM prepped_sleep_data
GROUP BY Bed_Time, Wake_Time, Notes
ORDER BY MIN(Hours_Recorded) ASC;

/* H7. What is the maximum number of hours slept in one entry?
- 13.46 hours on August 18, 2022 */
SELECT MAX(Hours_Recorded) AS HoursDescending, Bed_Time, Wake_Time, Notes
FROM prepped_sleep_data
GROUP BY Bed_Time, Wake_Time, Notes
ORDER BY MAX(Hours_Recorded) DESC;

/* H8. What is the total number of hours slept? What is the percentage of sleep for the duration?
- 17088.55 total recorded sleep hours, 33% of time was spent sleeping. */
SELECT SUM(Hours_Recorded) AS TotalSleepHrs
FROM prepped_sleep_data;

SELECT SUM(Hours_Recorded)/(COUNT(DISTINCT DATE(Entry_Date)) * 24)
AS PercentageTotalSleep
FROM prepped_sleep_data;

/* H9. How many entries could be considered naps? Assume a nap is no more than 4.00 recorded hours.
How many of these naps occur during the day? Day starts at 6:00 AM and ends at 10:00 PM.
- 129 potential naps, 55 naps during a normal 16-hr wake period */

SELECT COUNT(Bed_Time) AS Naps
FROM prepped_sleep_data
WHERE Hours_Recorded <= 4;

SELECT COUNT(Bed_Time) AS DayNaps
FROM prepped_sleep_data
WHERE Hours_Recorded <= 4
AND HOUR(Bed_Time) BETWEEN 06 AND 22;

/* H10. What do these naps look like?
- The longest nap was exactly 4.00 hours on Nov 23, 2019. Notes say "Manually added". */

SELECT Bed_Time, Wake_Time, Hours_Recorded AS NapLengthDesc, Notes 
FROM prepped_sleep_data
WHERE Hours_Recorded <= 4
AND HOUR(Bed_Time) BETWEEN 06 AND 22
ORDER BY Hours_Recorded DESC; 

/* H11. Is the added BOOLEAN column 'Nap' accurate?
- Yes. :) */
SELECT Nap, Hours_Recorded, Notes
FROM prepped_sleep_data
WHERE Hours_Recorded <= 4
ORDER BY Hours_Recorded DESC;

/* H12. How many naps are manually added? 
- 33 manually added naps */

SELECT COUNT(Nap) AS ManualNap
FROM prepped_sleep_data
WHERE Nap = 1 AND Notes LIKE "%anual%"
GROUP BY Nap;
