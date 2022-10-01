----------------------- COMBINE ALL THE DATA FOR 12 MONTHS INTO ONE TABLE -----------------------


INSERT INTO `case-study-361620.csdata.agg_data` (ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week)
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_04`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_05`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_06`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_07`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_08`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_09`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_10`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_11`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_12`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_2101`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_2102`
union all
SELECT
ride_id, rideable_type, started_at, ended_at, start_station_name, end_station_name, start_lat, start_lng, end_lat, end_lng, member_casual, ride_length, day_of_week
FROM
`case-study-361620.csdata.trip_data_2103`;


----------------------- DATA CLEANING  -----------------------

----------------------- Check for ride_id characters not equal to 16. And delete all if not. Check if records are distinct.

SELECT ride_id  
FROM `case-study-361620.csdata.agg_data`
where length(ride_id) != 16

DELETE FROM `case-study-361620.csdata.agg_data` 
WHERE length(ride_id) != 16 

SELECT COUNT (DISTINCT ride_id)
FROM `case-study-361620.csdata.agg_data`
WHERE length(ride_id) != 16 

SELECT rideable_type 
FROM `case-study-361620.csdata.agg_data` 
GROUP BY rideable_type;

-----------------------Replace docked_bike with classic_bike

UPDATE 
    `case-study-361620.csdata.agg_data`
SET
    rideable_type = REPLACE(rideable_type, 'docked_bike','classic_bike')
WHERE
    rideable_type IS NOT NULL;


-----------------------Check started_at / ended_at columns for ride length <1min and >24h

DELETE FROM `case-study-361620.csdata.Agg_data` WHERE ride_length <= '0:01:00'
DELETE FROM `case-study-361620.csdata.Agg_data` WHERE ride_length > '24:00:00'

-----------------------start_station_name / end_station_name check for maintenanse/test rides

DELETE FROM `case-study-361620.csdata.agg_data`
WHERE start_station_name LIKE ('%Base%') OR end_station_name LIKE ('%Base%');

DELETE FROM `case-study-361620.csdata.agg_data`
WHERE start_station_name LIKE ('%Test%') OR end_station_name LIKE ('%Test%');

DELETE FROM `case-study-361620.csdata.agg_data`
WHERE start_station_name LIKE ('%TEST%') OR end_station_name LIKE ('%TEST%');

DELETE FROM `case-study-361620.csdata.agg_data`
WHERE start_station_name LIKE ('%Temp%') OR end_station_name LIKE ('%Temp%');


----------------------- DATA ANALYSIS  -----------------------

-----------------------Member type distribution

SELECT member_casual,
COUNT(member_casual) AS member_casual_count
FROM `case-study-361620.csdata.agg_data`
GROUP BY member_casual;


-----------------------Rideable type count

SELECT rideable_type, COUNT(rideable_type) AS rideable_type_count, member_casual
From `case-study-361620.csdata.agg_data`
Group by member_casual, rideable_type

-----------------------Average trip duration

SELECT member_casual, 
ROUND(AVG(DATE_DIFF (ended_at, started_at, minute)),0) AS Average
FROM `case-study-361620.csdata.agg_data`
group by member_casual

-----------------------Casual and member trip count by day of the week

SELECT member_casual, day_of_week, count(ride_id) AS Ride_Count
FROM `case-study-361620.csdata.agg_data`
Group by member_casual, day_of_week
Order by  member_casual

-----------------------Top 10 start/end stations names preferred by member and casual users

SELECT start_station_name, count(ride_id) AS ride_count_member, start_lat, start_lng,
FROM `case-study-361620.csdata.agg_data`
Where member_casual IN ('member')
GROUP BY start_station_name, member_casual
ORDER BY ride_count_member DESC
Limit 10

SELECT end_station_name, count(ride_id) AS ride_count_member,
FROM `case-study-361620.csdata.agg_data`
Where member_casual IN ('member')
GROUP BY end_station_name, member_casual
ORDER BY ride_count_member DESC
Limit 10

SELECT start_station_name, count(ride_id) AS ride_count_casual, start_lat, start_lng,
FROM `case-study-361620.csdata.agg_data`
Where member_casual IN ('casual')
GROUP BY start_station_name, member_casual
ORDER BY ride_count_casual DESC
Limit 10

SELECT end_station_name, count(ride_id) AS ride_count_casual,
FROM `case-study-361620.csdata.agg_data`
Where member_casual IN ('casual')
GROUP BY end_station_name, member_casual
ORDER BY ride_count_casual DESC
Limit 10

-----------------------Average trip duration per day for casual and members

SELECT member_casual, day_of_week,
ROUND(AVG(DATE_DIFF(ended_at, started_at, minute)),0) AS Average_ride_time_min
FROM `case-study-361620.csdata.agg_data`
group by member_casual, day_of_week
order by day_of_week

-----------------------Average duration of rides with same start-end station, and different start-end station

Select count(ride_id) AS Ride_count,
ROUND(AVG(DATE_DIFF(ended_at, started_at, minute)),0) AS Average_ride_time_min
FROM `case-study-361620.csdata.agg_data`
WHERE start_station_name=end_station_name
Order by Average_ride_time_min DESC

Select count(ride_id) AS Ride_count,
ROUND(AVG(DATE_DIFF(ended_at, started_at, minute)),0) AS Average_ride_time_min
FROM `case-study-361620.csdata.agg_data`
WHERE start_station_name!=end_station_name
Order by Average_ride_time_min DESC

-----------------------Ride count by part of day for members and casual 

SELECT COUNT(ride_id) AS Ride_Count, member_casual,
CASE 
WHEN TIME(started_at) > '05:59:59' AND TIME(started_at) < '11:59:59' THEN 'Morning'
WHEN TIME(started_at) > '11:59:59' AND TIME(started_at) < '17:59:59' THEN 'Afternoon'
WHEN TIME(started_at) > '18:59:59' AND TIME(started_at) < '23:59:59' THEN 'Evening'
ELSE 'Nigth' 
END AS Part_Of_Day,
FROM  `case-study-361620.csdata.agg_data`
Group by  Part_of_Day, member_casual
ORDER BY Ride_count DESC


THE END.








