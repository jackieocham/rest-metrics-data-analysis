-- Multivariate Non-Graphical Analysis -- 
-- On days when I woke up before 7:00 AM, what time did I go to bed? --
-- Chart noise vs deep sleep to observe correlation. --
-- How did my hours of sleep change with different treatments? --
-- Treatment 1
-- Treatment 2
-- Treatment 3
-- Treatment 4
-- Treatment 5
-- How did my proportion of deep sleep change with different treatments? --
-- Treatment 1
-- Treatment 2
-- Treatment 3
-- Treatment 4
-- Treatment 5
-- How did my Epworth Sleepiness Scale scores change with different treatments? --
-- Treatment 1
-- Treatment 2
-- Treatment 3
-- Treatment 4
-- Treatment 5 
-- How did my day time naps change with different treatments? --
SELECT *
FROM prepped_sleep_data
WHERE `Comment` LIKE '%nap%';
# Only returns 17 rows. Not enough entries where I tracked naps