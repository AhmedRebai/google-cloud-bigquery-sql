-- Task 1. Create BigQuery dataset and tables using DDL statements


-- create schema if not exists animals_dataset options(location="us");

-- create table animals_dataset.owners (OwnerID int64 not null, name string);

-- create table animals_dataset.pets(
--   PetID int64 not null,
--   OwnerID int64 not null, 
--   Type string,
--   Name string,
--   Weight float64
-- );

-- load data into animals_dataset.owners 
-- from files (
--   skip_leading_rows = 1,
--   format = 'CSV',
--   field_delimiter = ',',
--   uris = ['gs://tcd_repo/data/environmental/animals/owners.csv']
-- );

load data into animals_dataset.pets 
from files (
  skip_leading_rows = 1,
  format = 'CSV',
  field_delimiter = ",",
  uris = ['gs://tcd_repo/data/environmental/animals/pets.csv']
);

-- Task 2. Update BigQuery table data using DML statements

INSERT INTO 
  animals_dataset.owners (OwnerID, Name) 
VALUES 
  (9, 'Mary'); 

INSERT INTO 
  animals_dataset.pets (PetID, OwnerID, Type, Name, Weight) 
VALUES 
    (28, 9, 'Dog', "George", 50); 


INSERT INTO 
  animals_dataset.pets (PetID, OwnerID, Type, Name, Weight) 
VALUES 
  (29, 9, 'Dog', "Washington", 60);

SELECT o.Name, p.Type, p.Name 
FROM 
  animals_dataset.owners o 
JOIN 
  animals_dataset.pets p 
ON 
  o.OwnerID = p.OwnerID
WHERE 
  o.Name = 'Mary'; 

UPDATE 
  animals_dataset.pets
SET 
  Type = 'Canine'
WHERE 
  Type = 'Dog'; 

DELETE FROM
  animals_dataset.pets
WHERE 
  Type = 'Frog';

-- Task 3. Join data and write CTEs using SQL SELECT statements


-- -- -- -- SELECT 
-- -- -- --   o.Name, p.Type, p.Name, p.Weight 
-- -- -- -- FROM 
-- -- -- --   animals_dataset.owners o 
-- -- -- -- JOIN 
-- -- -- --   animals_dataset.pets p 
-- -- -- -- ON 
-- -- -- --   o.OwnerID = p.OwnerID; 

-- -- -- SELECT 
-- -- --   o.Name, p.Type, p.Name, p.Weight 
-- -- -- FROM 
-- -- --   animals_dataset.owners o 
-- -- -- JOIN 
-- -- --   animals_dataset.pets p
-- -- -- ON 
-- -- --   o.OwnerID = p.OwnerID 
-- -- -- WHERE 
-- -- --   p.Type = "Canine"; 

-- -- SELECT 
-- --   o.Name, p.Type, p.Name, p.Weight 
-- -- FROM 
-- --   animals_dataset.owners o 
-- -- JOIN 
-- --   animals_dataset.pets p
-- -- ON 
-- --   o.OwnerID = p.OwnerID 
-- -- WHERE 
-- --   p.Type = "Canine"
-- -- ORDER BY 
-- --   o.Name ASC;

-- SELECT 
--   type, COUNT(*) AS count 
-- FROM 
--   animals_dataset.pets 
-- GROUP BY 
--   type
-- ORDER BY 
--   count DESC;

-- SELECT 
--   o.Name, COUNT(p.Name) AS count 
-- FROM 
--   animals_dataset.owners o 
-- JOIN 
--   animals_dataset.pets p 
-- ON 
--   o.OwnerID = p.OwnerID
-- GROUP BY 
--   o.Name
-- ORDER BY 
--   count DESC; 

-- SELECT 
--   o.OwnerID, 
--   o.Name AS OwnerName, 
--   ARRAY_AGG(STRUCT( 
--     p.Name AS PetName, 
--     p.Type, 
--     p.Weight)) AS Pets 
-- FROM 
--   animals_dataset.owners AS o 
-- JOIN 
--   animals_dataset.pets AS p 
-- ON 
--   o.OwnerID = p.OwnerID
-- GROUP BY 
--   o.OwnerID, o.Name; 

WITH owners_pets AS (SELECT 
  o.OwnerID, 
  o.Name AS OwnerName, 
  ARRAY_AGG(STRUCT( 
    p.Name AS PetName, 
    p.Type, 
    p.Weight)) AS Pets
FROM 
  animals_dataset.owners AS o 
JOIN 
  animals_dataset.pets AS p 
ON 
  o.OwnerID = p.OwnerID 
GROUP BY 
  o.OwnerID, o.Name) 
SELECT 
  op.OwnerName, op.Pets 
FROM 
  owners_pets AS op;


-- Task 4. Create new tables and views using DDL statements

-- -- CREATE OR REPLACE TABLE 
-- --   animals_dataset.owners_pets AS (
-- --   SELECT 
-- --     o.OwnerID, 
-- --     o.Name AS OwnerName, 
-- --     ARRAY_AGG(STRUCT(
-- --       p.PetID, 
-- --       p.Name AS PetName, 
-- --       p.Type, 
-- --       p.Weight)) AS Pets 
-- --   FROM 
-- --     animals_dataset.owners AS o 
-- --   JOIN 
-- --     animals_dataset.pets AS p 
-- --   ON 
-- --     o.OwnerID = p.OwnerID
-- --   GROUP BY 
-- --     o.OwnerID, o.Name
-- --   );

-- SELECT 
--   OwnerName, 
--   ARRAY_LENGTH(Pets) AS count 
-- FROM 
--   animals_dataset.owners_pets 
-- ORDER BY 
--   count DESC;

-- CREATE OR REPLACE VIEW
--   animals_dataset.small_pets AS ( 
--   SELECT 
--     * 
--   FROM 
--     animals_dataset.pets
--   WHERE 
--     weight <= 20
--   );

CREATE OR REPLACE MATERIALIZED VIEW 
  animals_dataset.pet_weight_by_type AS ( 
  SELECT 
    type, 
    SUM(Weight) AS total_weight 
  FROM 
    animals_dataset.pets
  GROUP BY 
    type 
  );

-- Task 5. Define custom UDFs and stored procedures

-- CREATE OR REPLACE FUNCTION animals_dataset.PoundsToKilos(pounds FLOAT64) 
-- AS ( 
--   round(pounds / 2.2, 1) 
-- );

-- SELECT 
--   name, 
--   weight AS pounds, 
--   animals_dataset.PoundsToKilos(Weight) AS Kilos 
-- FROM 
--   animals_dataset.pets;

-- CREATE OR REPLACE PROCEDURE animals_dataset.create_pet( 
--   customerID INT64, type STRING, name STRING, weight FLOAT64, out newPetID INT64) 
-- BEGIN
-- SET newPetID = (SELECT MAX(PetID) + 1 FROM animals_dataset.pets); 
-- INSERT INTO animals_dataset.pets (PetID, OwnerID, Type, Name, Weight) 
--     VALUES(newPetID, customerID, type, name, weight); 
-- END

DECLARE newPetID INT64; 
CALL animals_dataset.create_pet(1, 'Dog', 'Duke', 15.0, newPetID); 
SELECT * 
FROM 
  animals_dataset.pets 
WHERE 
  PetID = newPetID;

DECLARE newPetID INT64; 
CALL animals_dataset.create_pet(4, 'Cat', 'Fluffy', 6.0, newPetID); 
SELECT * 
FROM 
  animals_dataset.pets 
WHERE 
  PetID = newPetID;

SELECT * 
FROM 
  animals_dataset.pets 
WHERE 
  Name in ('Duke', 'Fluffy');



