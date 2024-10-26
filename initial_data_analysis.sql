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

SELECT DATE(Bed_Time)
FROM prepped_sleep_data
ORDER BY Bed_Time ASC LIMIT 1;
SELECT Entry_Date
FROM prepped_health_data
ORDER BY Entry_Date ASC LIMIT 1; 

/* G2. What date was tracking data last exported?
- sleep: 2024-10-20 
- health: 2024-10-20 */

SELECT DATE(Wake_Time)
FROM prepped_sleep_data
ORDER BY Bed_Time DESC LIMIT 1;
SELECT Entry_Date
FROM prepped_health_data
ORDER BY Entry_Date DESC LIMIT 1;

/* G3. How many total entries?
- sleep: 2286
- health: 3018 */

SELECT COUNT(Id)
FROM prepped_sleep_data;
SELECT COUNT(Entry_Date)
FROM prepped_health_data;

/* G4. What was the adherence to using these trackers? How many days missed tracking?
- sleep: 24 missing days, 98.9% adherence to tracking for the duration
    * Date range Oct 30, 2018 - Oct 20, 2024 includes 2,182 days.
- health: 836 missing days, 78.31% adherence to tracking for the duration
    * Date range Apr 02, 2014 - Oct 20, 2024 includes 3,854 days. */

SELECT 2182 - COUNT(DISTINCT DATE(Wake_Time))
FROM prepped_sleep_data;
SELECT COUNT(DISTINCT DATE(Wake_Time))/2182
FROM prepped_sleep_data;
SELECT 3854 - COUNT(DISTINCT(Entry_Date))
FROM prepped_health_data;
SELECT COUNT(DISTINCT(Entry_Date))/3854
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
- 111 manually added sleep records
	* The app runs in the background and estimates sleep times after waking in the morning, 
    giving an option to manually add sleep duration. */

SELECT COUNT(Notes)
FROM prepped_sleep_data
WHERE Notes LIKE "Manually%";

/* G7. How many sleep tracking entries start and end on the same day?
- 1575 entries
	* These are entries when sleep tracking started after midnight or a nap was taken. */
    
SELECT COUNT(Id)
FROM prepped_sleep_data
WHERE DATE(Bed_Time) = DATE(Wake_Time) AND Hours_Recorded > 5;


-- DATA ON *HOURS* OF SLEEP -- 

/* H1. How many entries show 7.5 hrs of sleep?
- 1270 entries, which is about 40 months or about 3.5 years
    * Answer is not immediately clear using this query, had to look at row(s) returned in the 'Action Output' window. */

SELECT Hours_Recorded
FROM prepped_sleep_data
WHERE Hours_Recorded > 7.5;

/* H2. How many entries show at least 7.5 hrs of sleep?
- 1282 entries, which is about 41 months or about 3.5 years
    * Aliasing using AS replaces "COUNT(Hours_Recorded)" with "enoughSleep".
    * SELECT COUNT(*) also works but is not as efficient - it is faster to count one field than to count everything. */

SELECT COUNT(Hours_Recorded) AS enoughSleep 
FROM prepped_sleep_data
WHERE Hours_Recorded >= 7.5;

/* H3. What percentage of entries show at least 7.5 hrs of sleep?
- 43.94% of entries show 7.5 hrs of sleep
	* This data does not include my sleep tracking from my health app. Revisit to update later. */
    
SELECT(
(SELECT COUNT(Id) FROM prepped_sleep_data) - COUNT(Hours_Recorded)
)/(SELECT COUNT(Id) FROM prepped_sleep_data)
AS percentEnoughSleep
FROM prepped_sleep_data
WHERE Hours_Recorded >= 7.5;

/* H4. How many entries with 6 or less hrs of sleep?
- 328 entries with 6 or less hrs of sleep */

SELECT COUNT(Hours_Recorded) AS countLessThan6hrs
FROM prepped_sleep_data
WHERE Hours_Recorded <= 6;

/* H5. What is the average number of hours slept?
- 7.48 average hours 
    * Some of the hours slept could be from naps. Investigate further. */

SELECT AVG(Hours_Recorded) AS avgHrsSlept
FROM prepped_sleep_data;

/* H6. How many entries could be naps during the day?
- 63 potential naps */

SELECT COUNT(Bed_Time)
FROM prepped_sleep_data
WHERE Hours_Recorded <= 6
AND HOUR(Bed_Time) BETWEEN 06 AND 21;

/* H7. What do these naps look like?
- It looks like there a quite a few nights stayed up until after 6:00 AM and then slept for less than 6 hours.
    * This is more of a late bed time with not enough sleep than a nap. Continue investigating. */

SELECT Bed_Time, Wake_Time, Hours_Recorded, Notes 
FROM prepped_sleep_data
WHERE Hours_Recorded <= 6
AND HOUR(Bed_Time) BETWEEN 06 AND 21
ORDER BY Hours_Recorded DESC; 

/* H8. How many potential naps if the sleep time recorded is changed to 5 hours and the wake-up hour which starts a day
changes from 6am to 7am? What do these naps look like?
- 47 potential naps
- These entries look more like naps. Sometimes naps happened after teaching a 6:00am fitness class.
	* The record with 4.9 Hours_Recorded on 2024-06-12 looks weird. I checked it against my calendar and it looks like 
    an anomaly. I slept June 11, 2024, 11:56pm – June 12, 2024, 6:58am and went back to sleep at 7:09am for some reason. */

SELECT COUNT(Bed_Time)
FROM prepped_sleep_data
WHERE Hours_Recorded <= 5
AND HOUR(Bed_Time) BETWEEN 07 AND 21;
# Answer: 47

SELECT Bed_Time, Wake_Time, Hours_Recorded, Notes 
FROM prepped_sleep_data
WHERE Hours_Recorded <= 5
AND HOUR(Bed_Time) BETWEEN 07 AND 21
ORDER BY Hours_Recorded DESC;
