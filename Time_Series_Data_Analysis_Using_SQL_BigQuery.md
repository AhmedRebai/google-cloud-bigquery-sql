# To select a few columns from a heavy table > 1.5 Go with SQL in BigQuery



``` sql
SELECT 
pickup_datetime, 
fare_amount, 
tip_amount 
FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2018`
order by fare_amount, tip_amount desc
```

