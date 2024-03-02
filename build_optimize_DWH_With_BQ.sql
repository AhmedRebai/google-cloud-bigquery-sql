-- Build and Optimize Data Warehouses with BigQuery: Challenge Lab

-- Task 1
CREATE OR REPLACE TABLE covid.oxford_policy_tracker 
PARTITION BY date OPTIONS ( partition_expiration_days=1080,description="COVID 19 data") 
AS 
SELECT * 
FROM bigquery-public-data.covid19_govt_response.oxford_policy_tracker
WHERE alpha_3_code != 'USA' AND alpha_3_code != 'GBR' AND alpha_3_code != 'BRA' AND alpha_3_code != 'CAN' 

-- Task 2 

CREATE OR REPLACE TABLE covid_data.country_area_data 
AS 
SELECT * 
FROM bigquery-public-data. census_bureau_international.country_names_area

-- Task 3 Create a new table for mobility record data
CREATE OR REPLACE TABLE covid_data.mobility_data 
AS 
SELECT * 
FROM bigquery-public-data.covid19_google_mobility.mobility_report

-- Task 4 Delete Null population and country area data from oxford_policy_tracker_by_countries table


ALTER TABLE covid.oxford_policy_tracker
ADD COLUMN population INT64,
ADD COLUMN country_area FLOAT64



CREATE OR REPLACE TABLE covid_data.pop_data_2019 AS
SELECT
  country_territory_code,
  pop_data_2019
FROM 
  `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`
GROUP BY
  country_territory_code,
  pop_data_2019
ORDER BY
  country_territory_code


-- -- -- CREATE OR REPLACE TABLE covid.oxford_policy_tracker 
-- -- -- PARTITION BY date OPTIONS ( partition_expiration_days=1080,description="COVID 19 data") 
-- -- -- AS 
-- -- -- SELECT * 
-- -- -- FROM bigquery-public-data.covid19_govt_response.oxford_policy_tracker
-- -- -- WHERE alpha_3_code != 'USA' 
-- -- -- AND alpha_3_code != 'GBR'
-- -- --  AND alpha_3_code != 'BRA'
-- -- --   AND alpha_3_code != 'CAN' 


-- -- ALTER TABLE qwiklabs-gcp-02-af1734e6ea42.covid_data.global_mobility_tracker_data
-- -- ADD COLUMN population INT64,
-- -- ADD COLUMN country_area FLOAT64,
-- -- ADD COLUMN mobility STRUCT<
-- --    avg_retail      FLOAT64,
-- --    avg_grocery     FLOAT64,
-- --    avg_parks       FLOAT64,
-- --    avg_transit     FLOAT64,
-- --    avg_workplace   FLOAT64,
-- --    avg_residential FLOAT64
-- --    >

-- UPDATE
-- covid_data.consolidate_covid_tracker_data t0
-- SET
-- t0.population = t2.pop_data_2019
-- FROM
-- (SELECT DISTINCT country_territory_code, pop_data_2019 FROM `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`) AS t2
-- WHERE t0.alpha_3_code = t2.country_territory_code;

UPDATE
   covid_data.consolidate_covid_tracker_data t0
SET
   t0.country_area = t1.country_area
FROM
   `bigquery-public-data.census_bureau_international.country_names_area` t1
WHERE
   t0.country_name = t1.country_name









