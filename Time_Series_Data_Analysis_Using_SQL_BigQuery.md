# To select a few columns from a heavy table > 1.5 Go with SQL in BigQuery



``` sql
SELECT 
pickup_datetime, 
fare_amount, 
tip_amount 
FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
order by fare_amount, tip_amount desc
```

# How to select the hour from a date column like this one "2018-01-01 04:10:01 UTC"
``` sql
select 
extract(HOUR from datetime(pickup_datetime)) as hour, 
count(*) as num_trips
from `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
group by hour
order by num_trips desc
```

# How to select the hour from a date column like this one "2018-01-01 04:10:01 UTC" and to group by the hour and to compute a KPI 
``` sql
select
extract(HOUR from pickup_datetime) as hour,
avg(fare_amount) as fare,
avg(tip_amount) as tip,
( avg(tip_amount) / avg(fare_amount) ) * 100 as perct_tip
from `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
group by hour
order by tip desc
```

# How to get the day names and to group by the weekday 
``` sql
select 
format_date('%A', pickup_datetime) as weekday,
count(*) as num_trips
from `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
group by weekday
order by num_trips desc
```

# How to lag with sql 
``` sql
select 
hour,
fare,
lag(fare) over (order by fare) as fare_lag
from (
  select 
  extract(hour from datetime(pickup_datetime)) as hour,
  avg(fare_amount) as fare
  from `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
  group by hour
  ) order by fare desc
 ```
 
 # How to resample by day 
 ``` sql 
 select 
  datetime_trunc(pickup_datetime,day) as time, 
  count(*) as num_trips
from `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
group by time
 ```
 
 # How to use With statement in sql 
 ``` sql 
 with daily_trips as (
select 
  datetime_trunc(pickup_datetime,day) as time, 
  count(*) as num_trips
from `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
group by time
)
select * from daily_trips
 ```
